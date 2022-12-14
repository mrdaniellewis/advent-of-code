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

def draw(grid)
  ys = grid.keys.map { _1[1] }
  xs = grid.keys.map { _1[0] }
  (ys.min..ys.max).map do |y|
    (xs.min..xs.max).map do |x|
      print grid[Vector[x, y]] || "."
    end
    print "\n"
  end
end

DOWN = Vector[0, 1]
LEFT = Vector[-1, 1]
RIGHT = Vector[1, 1]

BOTTOM = grid.keys.map { _1[1] }.max

draw grid
puts

queue = []

settled = 0
catch(:done) do
  loop do
    v = Vector[500, 0]
    queue << v

    queue.map! do |partical|
      new_pos = nil
      [DOWN, LEFT, RIGHT].each do |dir|
        pos = partical + dir
        break new_pos = pos unless grid[pos]
      end
      unless new_pos
        settled += 1
        next nil
      end

      throw :done if new_pos[1] >= BOTTOM

      grid[partical] = nil
      grid[new_pos] = "+"
      new_pos
    end.compact!
  end
end

draw grid
puts settled
