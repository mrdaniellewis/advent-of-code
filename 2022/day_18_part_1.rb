# frozen_string_literal: true

require "matrix"

data = $stdin.read

cubes = data.each_line(chomp: true).map do |line|
  Vector[*line.split(",").map(&:to_i)]
end

SIDES = [
  Vector[1, 0, 0],
  Vector[0, 1, 0],
  Vector[0, 0, 1],
  Vector[-1, 0, 0],
  Vector[0, -1, 0],
  Vector[0, 0, -1]
]

edges = Hash.new { |h, k| h[k] = 0 }

cubes.each do |cube|
  SIDES.each do |side|
    edges[cube + side] += 1
  end
end

pp edges.reject { |k| cubes.include?(k) }.values.sum
