# frozen_string_literal: true

require "matrix"

data = $stdin.read

lines = data.each_line(chomp: true).flat_map do |line|
  line.split(" -> ").map { |p| p.split(",").map(&:to_i).each_slice(2).map { Vector[_1, _2] }.first }.each_cons(2).to_a
end

grid = {}

lines.each do |(from, to)|
  Range.new(*[from[1], to[1]].sort).each do |y|
    Range.new(*[from[0], to[0]].sort).each do |x|
      grid[Vector[x, y]] = "#"
    end
  end
end

TOP = 0
BOTTOM = grid.keys.map { _1[1] }.max + 2

def draw(grid)
  ys = grid.keys.map { _1[1] }
  xs = grid.keys.map { _1[0] }
  (ys.min..ys.max).map do |y|
    (xs.min..xs.max).map do |x|
      print grid[Vector[x, y]] || "."
    end
    print "\n"
  end
  (xs.min..xs.max).map do
    print "#"
  end
  print "\n"
end

draw grid
puts

LEFT = Vector[-1, -1]
RIGHT = Vector[1, -1]
UP = Vector[0, -1]

grid[Vector[500, 0]] = "o"

count = 1

(0...BOTTOM).each_with_index do |y, i|
  (500 - i..500 + i).each do |x|
    next if grid[Vector[x, y]]

    free = grid[Vector[x, y] + UP] == "o" ||
           grid[Vector[x, y] + LEFT] == "o" ||
           grid[Vector[x, y] + RIGHT] == "o"

    next unless free

    count += 1
    grid[Vector[x, y]] = "o"
  end
end

draw grid
puts count
