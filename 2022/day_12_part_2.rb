# frozen_string_literal: true

require "matrix"

# Dijkstra algorithm with dials optimisation
# Start at the end, and then find the "a" location with the shortest distance
# Only change from part 1 is we need to step down

data = $stdin.read

GRID = data.each_line(chomp: true).flat_map.with_index do |row, y|
  row.chars.map.with_index do |c, x|
    case c
    when "S"
      START = Vector[y, x]
      [Vector[y, x], 0]
    when "E"
      FINISH = Vector[y, x]
      [Vector[y, x], 25]
    else
      [Vector[y, x], c.ord - "a".ord]
    end
  end
end.to_h

UP = Vector[-1, 0]
DOWN = Vector[1, 0]
LEFT = Vector[0, -1]
RIGHT = Vector[0, 1]

$distances = { FINISH => 0 }
buckets = [[FINISH]]

def debug
  max_h = GRID.values.max.to_s.length + 1
  max_d = $distances.values.max.to_s.length + 1
  puts
  puts((0..GRID.keys.map { _1[0] }.max).map do |y|
    (0..GRID.keys.map { _1[1] }.max).map do |x|
      GRID[Vector[y, x]].to_s.ljust(max_h) + $distances[Vector[y, x]].to_s.ljust(max_d)
    end.join(" | ")
  end.join("\n"))
end

loop do
  index = buckets.find_index(&:any?)

  break unless index

  loop do
    vector = buckets[index].shift
    current_distance = $distances[vector]
    current_height = GRID[vector]

    [UP, DOWN, LEFT, RIGHT].each do |dir|
      target = vector + dir

      target_height = GRID[target]
      next if target_height.nil? || current_height - target_height > 1

      distance = $distances[target]
      new_distance = current_distance + 1
      next if distance && distance <= new_distance

      $distances[target] = new_distance
      buckets[distance].delete(target) if distance
      buckets[new_distance] ||= []
      buckets[new_distance] << target
    end

    break if buckets[index].empty?
  end
end

pp $distances.filter { |v| GRID[v] == 0 }.values.min
