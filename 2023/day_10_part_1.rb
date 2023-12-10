# frozen_string_literal: true

require "matrix"
require "debug"

V = Vector
PRETTY = { "|" => "┃", "-" => "━", "7" => "┓", "F" => "┏", "L" => "┗", "J" => "┛" }

grid = {}
start = nil

ARGF.each_line.map(&:chomp).each_with_index do |line, y|
  line.chars.each_with_index do |c, x|
    next if c == "."

    grid[V[x, y]] = c
    start = V[x, y] if c == "S"
  end
end

def debug(grid, values)
  Range.new(*grid.keys.map { _1[1] }.minmax).each do |y|
    Range.new(*grid.keys.map { _1[0] }.minmax).each do |x|
      if values.include?(V[x, y])
        print values[V[x, y]]
      else
        print PRETTY[grid[V[x, y]]] || grid[V[x, y]] || " "
      end
    end
    print "\n"
  end
  puts
end

MOVES = [[0, -1], [1, 0], [0, 1], [-1, 0]].map { V[_1, _2] }
LEFT = Matrix[[0, 1], [-1, 0]]
RIGHT = Matrix[[0, -1], [1, 0]]
IDENTITY = Matrix.identity(2)
PIPES = {
  "-" => { V[1, 0] => IDENTITY, V[-1, 0] => IDENTITY },
  "|" => { V[0, 1] => IDENTITY, V[0, -1] => IDENTITY },
  "L" => { V[0, 1] => LEFT, V[-1, 0] => RIGHT },
  "F" => { V[0, -1] => RIGHT, V[-1, 0] => LEFT },
  "J" => { V[1, 0] => LEFT, V[0, 1] => RIGHT },
  "7" => { V[1, 0] => RIGHT, V[0, -1] => LEFT }
}

directions = MOVES.select do |move|
  type = grid[start + move]
  next unless type

  PIPES[type][move]
end

distances = { start => 0 }

directions.map! do |start_direction|
  Enumerator.new do |y|
    cursor = [start, start_direction]
    distance = 0
    loop do
      pos, direction = cursor
      new_pos = pos + direction
      break if new_pos == start || distances[new_pos]

      rotation = PIPES[grid[pos + direction]][direction]
      cursor = [new_pos, rotation * direction]
      y << new_pos
      distance += 1
      distances[new_pos] = distance
    end
  end
end

loop do
  directions.each(&:next)
rescue StopIteration
  break
end

pp distances.values.max
