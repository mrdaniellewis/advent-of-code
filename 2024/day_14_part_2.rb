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
      robots.include?(V[x, y]) ? "X" : "."
    end.join("")
  end.join("\n") + "\n\n")
end

draw_grid(robots.map(&:first))

X_CENTRE = X_RANGE.max / 2
pp X_CENTRE

seconds = 0
loop do
  lines = Hash.new { 0 }

  robots.each do |robot|
    position, velocity = robot

    x = (position[X] + velocity[X]) % X_RANGE.last
    y = (position[Y] + velocity[Y]) % Y_RANGE.last

    robot[0] = V[x, y]
    lines[x] += 1
  end

  seconds += 1
  next unless lines.any? { |_, l| l > 30 }

  puts
  puts seconds
  draw_grid(robots.map(&:first))
end
