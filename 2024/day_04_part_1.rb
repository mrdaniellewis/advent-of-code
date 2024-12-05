# frozen_string_literal: true

require "matrix"

grid = ARGF.each_line.map(&:chomp).each_with_object({}).with_index do |(line, g), y|
  line.chars.each_with_index do |c, x|
    g[Vector[x, y]] = c
  end
end

DIRECTIONS = ([-1, 0, 1].repeated_permutation(2).to_a - [[0, 0]]).map { Vector.elements _1 }

count = grid.sum do |(k, v)|
  next 0 unless v == "X"

  DIRECTIONS.count do |dir|
    p = k
    %w[M A S].all? do |c|
      p += dir
      grid[p] == c
    end
  end
end

pp count
