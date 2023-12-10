# frozen_string_literal: true

require "matrix"
require "debug"
require "colorize"

V = Vector
PRETTY = { "|" => "┃", "-" => "━", "7" => "┓", "F" => "┏", "L" => "┗", "J" => "┛" }
DIRS = { V[0, 1] => "v", V[0, -1] => "^", V[1, 0] => ">", V[-1, 0] => "<" }

grid = {}
start = nil

ARGF.each_line.map(&:chomp).each_with_index do |line, y|
  line.chars.each_with_index do |c, x|
    next if c == "."

    grid[V[x, y]] = c
    start = V[x, y] if c == "S"
  end
end

def debug(grid, other = {}, missing: " ")
  Range.new(*grid.keys.map { _1[1] }.minmax).each do |y|
    Range.new(*grid.keys.map { _1[0] }.minmax).each do |x|
      if (f = other.find { _2.include?(V[x, y]) })
        print f[0]
      else
        print PRETTY[grid[V[x, y]]] || grid[V[x, y]] || missing
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

start_direction = MOVES.find do |move|
  type = grid[start + move]
  next unless type

  PIPES[type][move]
end

cursor = [start, start_direction]
visited = Set[start]
left = Set.new
right = Set.new

loop do
  pos, direction = cursor
  left << pos + LEFT * direction
  right << pos + RIGHT * direction
  new_pos = pos + direction
  break if new_pos == start

  visited << new_pos
  left << new_pos + LEFT * direction
  right << new_pos + RIGHT * direction
  rotation = PIPES[grid[pos + direction]][direction]
  cursor = [new_pos, rotation * direction]
end

grid.delete_if { !visited.include?(_1) }
left.delete_if { grid.include?(_1) }
right.delete_if { grid.include?(_1) }

def fill_in(grid, positions)
  max_x = grid.keys.map { _1[0] }.max
  max_y = grid.keys.map { _1[1] }.max
  check = positions.dup.to_a - grid.keys
  loop do
    check = check.flat_map do |pos|
      MOVES.map do |dir|
        new_pos = pos + dir
        x, y = new_pos.to_a
        next if grid[new_pos] || positions.include?(new_pos) || x < 0 || y < 0 || x > max_x || y > max_y

        positions << new_pos
        new_pos
      end.compact
    end
    break if check.empty?
  end
end

fill_in(grid, left)
fill_in(grid, right)

debug(grid, { "L" => left, "R" => right }, missing: "◈".red)

inside = left.to_a.map { _1[0] }.min < right.to_a.map { _1[0] }.min ? right : left
pp inside.size
