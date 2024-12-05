# frozen_string_literal: true

require "matrix"

grid = ARGF.each_line.map(&:chomp).each_with_object({}).with_index do |(line, g), y|
  line.chars.each_with_index do |c, x|
    g[Vector[x, y]] = c
  end
end

DIRECTIONS = ([-1, 0, 1].repeated_permutation(2).to_a - [[0, 0]]).map { Vector.elements _1 }

count = grid.count do |(k, v)|
  next false unless v == "A"

  [grid[k + Vector[-1, -1]], grid[k + Vector[1, 1]]].compact.sort == %w[M S] &&
    [grid[k + Vector[-1, 1]], grid[k + Vector[1, -1]]].compact.sort == %w[M S]
end

pp count
