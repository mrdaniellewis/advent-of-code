# frozen_string_literal: true

require "matrix"

hails = ARGF.each_line.map(&:chomp).map do |line|
  pos, velocity = line.split(" @ ")
  [Vector[*pos.split(", ").map(&:to_i)], Vector[*velocity.split(", ").map(&:to_i)]]
end

# I did not figure this out myself! Had to look on reddit
#
# We can construct a set of simultaneous equations
#
# rock start = [BX, BY, BZ]
# rock velocity = [VX, VY, VZ]
#
# BX + VX t = bx + vx t
# BY + VY t = by + vy t
# BZ + VZ t = bz + vz t
#
# (BX - bx) / (vx - VX) = t
# (BX - bx) / (vx - VX) = (BY - by) / (vy - VY)
# (BX - bx) (vy - VY) = (BY - by) (vx - VX)
# BX vy - BX BY - bx vy + bx VY = BY vx - BY VX - by vx + by VX
# BY VX - BX BY = BY vx - by vx + by VX - BX vy + bx vy - bx VY
#
# Considering two separate hails
#
# BY v1x - b1y v1x + b1y VX - BX v1y + b1x v1y - b1x VY = BY v2x - b2y v2x + b2y VX - BX v2y + b2x v2y - b2x VY
# (v1x - v2x) BY + (b1y - b2y) VX + (v2y - v1y) BX + (b2x -b1x) VY = b2x v2y + b1y v1x - b1x v1y - b2y v2x
#
# Giving 4 unknowns repeat for 3 hails and also in z
#
# (v1x - v2x) BY + (b1y - b2y) VX + (v2y - v1y) BX + (b2x -b1x) VY = b2x v2y + b1y v1x - b1x v1y - b2y v2x
# (v1x - v3x) BY + (b1y - b3y) VX + (v3y - v1y) BX + (b3x -b1x) VY = b3x v3y + b1y v1x - b1x v1y - b3y v3x
# (v3x - v2x) BY + (b3y - b2y) VX + (v2y - v3y) BX + (b2x -b3x) VY = b2x v2y + b3y v3x - b3x v3y - b2y v2x
#
# (v1y - v2y) BY + (b1y - b2y) VY + (v2y - v1y) BY + (b2y -b1y) VY = b2y v2y + b1y v1y - b1y v1y - b2y v2y
# (v1y - v3y) BY + (b1y - b3y) VY + (v3y - v1y) BY + (b3y -b1y) VY = b3y v3y + b1y v1y - b1y v1y - b3y v3y
# (v3y - v2y) BY + (b3y - b2y) VY + (v2y - v3y) BY + (b2y -b3y) VY = b2y v2y + b3y v3y - b3y v3y - b2y v2y
#
# (v1x - v2x) BZ + (b1z - b2z) VX + (v2z - v1z) BX + (b2x -b1x) VZ = b2x v2z + b1z v1x - b1x v1z - b2z v2x
# (v1x - v3x) BZ + (b1z - b3z) VX + (v3z - v1z) BX + (b3x -b1x) VZ = b3x v3z + b1z v1x - b1x v1z - b3z v3x
# (v3x - v2x) BZ + (b3z - b2z) VX + (v2z - v3z) BX + (b2x -b3x) VZ = b2x v2z + b3z v3x - b3x v3z - b2z v2x
#
# We now have 6 unknowns and 9 equations

# (b1y - b2y) VX + (b2x - b1x) VY + (v2y - v1y) BX + (v1x - v2x) BY = b2x v2y + b1y v1x - b1x v1y - b2y v2x
# (b2y - b1y) VX + (b1x - b2x) VY + (v1y - v2y) BX + (v2x - v1x) BY = v2x b2y - v2y b2x - v1x b1y + v1y b1x

B = 0
V = 1

def row(h1, h2, x, y)
  #  (v2y - v1y) BX + (v1x - v2x) BY + (b1y - b2y) VX + (b2x - b1x) VY = b2x v2y + b1y v1x - b1x v1y - b2y v2x
  v = [
    0, # bx
    0, # by
    0, # bz
    0, # vx
    0,
    0,
    h2[B][x] * h2[V][y] + h1[B][y] * h1[V][x] - h1[B][x] * h1[V][y] - h2[B][y] * h2[V][x]
  ]
  v[x] = h2[V][y] - h1[V][y]
  v[y] = h1[V][x] - h2[V][x]
  v[x + 3] = h1[B][y] - h2[B][y]
  v[y + 3] = h2[B][x] - h1[B][x]
  v
end

h1, h2, h3 = hails.sample(3)

matrix = Matrix[
  row(h1, h2, 0, 1),
  row(h1, h2, 0, 2),
  row(h1, h2, 1, 2),
  row(h1, h3, 0, 1),
  row(h1, h3, 0, 2),
  row(h1, h3, 1, 2),
  row(h2, h3, 0, 1),
  row(h2, h3, 0, 2),
  row(h2, h3, 1, 2)
]

# lup.solve is a gussian elemination solver
puts Matrix.columns(matrix.column_vectors[0..-2]).lup.solve(matrix.column_vectors.last).to_a[0..2].sum.to_i
