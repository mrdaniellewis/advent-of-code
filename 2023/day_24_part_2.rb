# frozen_string_literal: true

require "debug"
require "matrix"
V = Vector
X = 0
Y = 1
Z = 2

class Line
  attr_reader :base, :slope

  def initialize(base, slope)
    @base = base
    @slope = slope
  end

  def dimensions(a1, a2)
    Line.new(V[base[a1], base[a2]], V[slope[a1], slope[a2]])
  end

  # https://stackoverflow.com/a/73079842
  def self.intersections(line1, line2)
    m = Matrix.columns([Vector[*line1.slope.to_a.take(2)], -Vector[*line2.slope.to_a.take(2)]])
    return nil if m.determinant.zero?

    parts = m.inverse * (Vector[*line2.base.to_a.take(2)] - Vector[*line1.base.to_a.take(2)])
    return parts unless line1.slope.size >= 3

    (2...line1.slope.size).all? do |axis|
      line1.base[axis] + line1.slope[axis] * parts[0] == line2.base[axis] + line2.slope[axis] * parts[1]
    end && parts
  end

  def intersection_3d(line)
    [X, Y, Z].combination(2).to_a.select do |a1, a2|
      dimensions(a1, a2).intersection(line.dimensions(a1, a2))
    end
  end

  def intersection(line)
    i = self.class.intersections(self, line)
    return nil unless i

    @base + @slope * i[0]
  end
end

class Hail
  attr_reader :name, :start, :velocity

  @@namer = ("A"..).to_enum

  def initialize(start, velocity)
    @name = @@namer.next
    @start = start
    @velocity = velocity
  end

  def to_line
    Line.new(start, velocity)
  end

  def intersection(h)
    to_line.intersection(h.to_line)
  end

  def intersections(h)
    Line.intersections(to_line, h.to_line)
  end
end

hails = ARGF.each_line.map(&:chomp).map do |line|
  pos, velocity = line.split(" @ ")
  Hail.new(
    V[*pos.split(", ").map(&:to_i)],
    V[*velocity.split(", ").map(&:to_i)]
  )
end

(1..1000).each do |t1|
  pp "t1=#{t1}"
  (1..1000).each do |t2|
    pp "t2=#{t2}"
    hails
      .permutation(2)
      .each do |h1, h2|
        h1 = h1.start + h1.velocity * t1
        h2 = h2.start + h2.velocity * t2
        b = h1
        v = h2 - h1

        found = hails.all? do |h|
          Line.intersections(h.to_line, Line.new(b, v))
        end

        if found
          pp [h1, h2, t1, t2, b, v]
          exit
        end
      end
  end
end

exit

hails
  .permutation(2)
  .select do |(h1, h2)|
    p1 = h1.start + h1.velocity * 1
    p2 = h2.start + h2.velocity * 3

    v = p2 - p1

    hails.all? do |ht|
      ht.to_line.intersection_3d(Line.new(p1, v))
    end
  end
  .then { pp _1 }

exit

hails
  .map do |hail|
    hail.start[2]
  end
  .sort
  .each_cons(2)
  .map { _2 - _1 }
  .then { puts _1 }

exit

1001.times.map do |t|
  hails
    .map do |hail|
      hail.start[0] + hail.velocity[0] * t
    end
end => positions

pp positions
exit

x = -3
t = 0
diffs = []
until t > 1000
  p = t * -3
  pp [t, positions[t].map { _1 - p }]
  positions[t].map { _1 - p }.each_with_index do |d, i|
    diffs[d] ||= Set.new
    diffs[d] << i
  end

  t += 1
end

pp diffs
pp t

exit

# 0   -3  -6  -9
#
# 19  17  15  13
# 18  17  16  15x
# 20  18  16  14
# 12  11  10  9
# 20  21x 22  23
#
#     24      24

# D + V * t = x + v * t

exit

(-1000..1000).each do |i|
  hails
    .map do |hail|
      hail.start[X] + hail.velocity[X] * i
    end
    .sort
    .then { pp [i, _1] }

  # .each_cons(2)
  # .to_a
  # .map { _2 - _1 }
  # .then { pp [i, _1] }
end

exit

velocities = hails
  .map(&:velocity)
  .map(&:to_a)
  .transpose
  .map do |a|
    min, max = a.minmax
    Range.new(min, max).to_a.reject { a.include?(_1) }
  end

pp velocities.map(&:size).reduce(:*)

exit

# .then do |values|
#   min, max = values.minmax
#   r = Range.new(min, max)
#   pp r.size
#   r.to_a.reject { values.include?(_1) }
# end
# .then { pp _1.size }

exit

hails
  .combination(2)
  .to_a
  .select do |(h1, h2)|
    intersections = h1.intersections(h2)
    next false if intersections.nil? || intersections.any? { _1 < 0 }

    intersection = h1.intersection(h2)
    intersection.to_a.all? { RANGE.include?(_1) }
  end
  .size
  .then { pp _1 }

# Find a vector one away

# b1x + v1x * t1 = Bx + Vx * t1
# b2x + v2x * t2 = Bx + Vx * t2
# b3x + v3x * t3 = Bx + Vx * t3

# b1y + v1y * t1 = By + Vy * t1
# b1z + v1z * t1 = Bz + Vz * t1

# b1x = Bx + Vx * t1 - V1x * t1
# b1x = Bx + (Vx - V1x) * t1
# 19 = Bx + (Vx + 2) * t1

# b1y + v1y * t1 = By + Vy * t1
# b1y - By = Vy * t1 - v1y * t1
# b1y - By = (Vy - v1y) * t1

# b1x - Bx = (Vx - v1x) * t1
# (b1x - Bx) / (Vx - v1x) = t1
# (b1y - By) / (Vy - v1y) = t1
# (b1z - Bz) / (Vz - v1z) = t1

# (b1x - Bx) / (Vx - v1x) = (b1y - By) / (Vy - v1y) = (b1z - z) / (Vz - v1z)
# (b2x - Bx) / (Vx - v2x) = (b2y - By) / (Vy - v2y) = (b2z - Bz) / (Vz - v2z)

# b2x + v2x * t2 = Bx + Vx * t2
# b2y + v2y * t2 = By + Vy * t2
# b2z + v2z * t2 = Bz + Vz * t2

# (b1x - Bx) / vdx = (b1y - By) / vdy = (b1x - Bz) / vdz

# (b1x - Bx) * vdy = (b1y - By) * vdx
# (b1x * vdx) - Bx * vdy = b1y * vdx - By * vdx
# (b1x * vdx) - (b1y * vdx) = - By * vdx + Bx * vdy
# (b1x * vdx) - (b1y * vdx) = Bx * vdy - By * vdx
# 0 = ax + by + c

# Linear Diophantine equations https://en.wikipedia.org/wiki/Diophantine_equation#One_equation
# c multiple of gcd

# 1. Find limited set of possible vectors
# 2. For each vector
#   1. calculate components of the Linear Diophantine equation
#   2. c is multiple of gcd of a and b
#   3.

# x3 + v3 * t3 = B + V * t3

__END__

[m_x_1, m_y_1]*t + [b_x_1, b_y_1] == [m_x_2, m_y_2]*t + [b_x_2, b_y_2]

|m_x_1, -m_x_2| * r = |b_x_2 - b_x_1|
|m_y_1, -m_y_2|       |b_y_2 - b_y_1|

|V1x, -Vx| * |1| * r = |Bx - b1x|
|Vy1, -Vy|   |1|       |By - b1y|

|V1x * -Vx * r| = |Bx - b1x|
|Vy1 * -Vy * r|   |By - b1y|

(V1x - Vx) * t = Bx - b1x
(Vy1 - Vy) * t = By - b1y


(V1x - Vx) = (Bx - b1x) / t
(Vy1 - Vy) = (By - b1y) / t

x1 + v1 * t1 - v * t1 = x
x2 + v2 * t2 - v * t2 = x
x3 + v3 * t3 - v * t3 = x
x4 + v4 * t4 - v * t4 = x
x5 + v5 * t5 - v * t5 = x


