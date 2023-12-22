# frozen_string_literal: true

require "matrix"
V = Vector

start = nil
count = ARGV.shift.to_i
GRID = ARGF.each_line.map(&:chomp).each_with_object(Set.new).with_index do |(line, h), y|
  line.chars.each_with_index do |char, x|
    h << V[x, y] if ".S".include?(char)
    start = V[x, y] if char == "S"
  end
end

XRANGE = Range.new(*GRID.map { _1[0] }.minmax)
YRANGE = Range.new(*GRID.map { _1[1] }.minmax)

def debug(distances)
  YRANGE.map do |y|
    XRANGE.map do |x|
      pos = V[x, y]
      if distances.key?(pos) then distances[pos]
      elsif GRID.include?(pos) then "."
      else
        "#"
      end
    end.join("")
  end.join("\n") + "\n\n"
end

DIRECTIONS = [V[0, 1], V[0, -1], V[1, 0], V[-1, 0]]

distances = Hash.new { Float::INFINITY }
distances[start] = 0
heads = [[start, 0]]

loop do
  heads = heads.flat_map do |(head, distance)|
    distance += 1
    DIRECTIONS
      .map { head + _1 }
      .select { GRID.include?(_1) }
      .select do |pos|
        if distances[pos] > distance
          distances[pos] = distance if distance.even?
          true
        else
          false
        end
      end
      .map { [_1, distance] }
  end

  break if heads.empty?
end

puts debug(distances.map.select { _2 <= count }.to_h)

pp distances.map.select { _2 <= count }.size
