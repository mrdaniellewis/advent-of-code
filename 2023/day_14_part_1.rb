# frozen_string_literal: true

require "debug"
require "matrix"
V = Vector

grid = ARGF.each_line.map(&:chomp).each_with_object({}).with_index do |(line, g), y|
  line.chars.each_with_index do |char, x|
    next if char == "."

    g[V[x, y]] = char
  end
end

def debug(grid)
  xrange = Range.new(*grid.keys.map { _1[0] }.minmax)
  Range.new(*grid.keys.map { _1[1] }.minmax).each do |y|
    xrange.each do |x|
      print grid[V[x, y]] || "."
    end
    print "\n"
  end
  puts
end

def tilt(grid)
  loop do
    modified = false
    grid = grid.each_with_object({}) do |(k, v), new|
      if v != "O" || k[1] == 0
        new[k] = v
      elsif grid[k - V[0, 1]]
        new[k] = v
      else
        modified = true
        new[k - V[0, 1]] = v
      end
    end

    debug(grid)

    break unless modified
  end
  grid
end

def load(grid)
  ymax = grid.keys.map { _1[1] }.max
  grid.map do |k, v|
    next 0 if v != "O"

    ymax - k[1] + 1
  end.sum
end

grid = tilt(grid)

pp load(grid)
