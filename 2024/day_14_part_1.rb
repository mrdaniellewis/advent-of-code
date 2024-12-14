# frozen_string_literal: true

require "matrix"
V = Vector

robots = ARGF.read.each_line.map(&:chomp).map do |line|
  x, y, vx, vy = line.scan(/-?\d+/).map(&:to_i)
  [V[x, y], V[vx, vy]]
end

X_RANGE = (0...(robots.length > 12 ? 101 : 11))
Y_RANGE = (0...(robots.length > 12 ? 103 : 7))
X = 0
Y = 1

def draw_grid(robots)
  print(Y_RANGE.map do |y|
    X_RANGE.map do |x|
      robots.count(V[x, y]).to_s.tr("0", ".")
    end.join("")
  end.join("\n") + "\n\n")
end

draw_grid(robots.map(&:first))

seconds = 0
loop do
  robots.each do |robot|
    position, velocity = robot

    x = (position[X] + velocity[X]) % X_RANGE.last
    y = (position[Y] + velocity[Y]) % Y_RANGE.last
    robot[0] = V[x, y]
  end

  seconds += 1
  break if seconds == 100
end

X_QUAD1 = (0...(X_RANGE.last / 2))
X_QUAD2 = ((X_RANGE.last - (X_RANGE.last / 2))..X_RANGE.max)
Y_QUAD1 = (0...(Y_RANGE.last / 2))
Y_QUAD2 = ((Y_RANGE.last - (Y_RANGE.last / 2))..Y_RANGE.max)

[[X_QUAD1, Y_QUAD1], [X_QUAD2, Y_QUAD1], [X_QUAD1, Y_QUAD2], [X_QUAD2, Y_QUAD2]]
  .map do |(xrange, yrange)|
    robots.count { xrange.include?(_1[0][X]) && yrange.include?(_1[0][Y]) }
  end
  .inject(:*)
  .then { pp _1 }
