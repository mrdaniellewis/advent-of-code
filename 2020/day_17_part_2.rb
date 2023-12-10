# frozen_string_literal: true

require "matrix"
V = Vector

grid = Set.new

ARGF.each_line.map(&:chomp).each_with_index do |line, y|
  line.chars.each_with_index do |c, x|
    grid << V[x, y, 0, 0] if c == "#"
  end
end

cycle = 0
directions = ([-1, 0, 1].repeated_permutation(4).to_a - [[0, 0, 0, 0]]).map { V.elements _1 }

until cycle == 6
  active_neighbours = Hash.new { 0 }
  grid.each do |pos|
    directions.each do |dir|
      active_neighbours[pos + dir] += 1
    end
  end

  grid = Set.new(active_neighbours.select { _2 == 3 || _2 == 2 && grid.include?(_1) }.keys)
  cycle += 1
end

pp grid.count
