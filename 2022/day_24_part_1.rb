# frozen_string_literal: true

require "matrix"
require "set"

V = Vector
X = 0
Y = 1

data = $stdin.read

grid = Hash.new { |h, k| h[k] = [] }

$xmax = 0
$ymax = 0

data.each_line(chomp: true).with_index do |line, y|
  next if y == 0 || line.match?(/^##/)

  $ymax = y - 1 if y - 1 > $ymax

  line.chars[1...-1].each_with_index do |char, x|
    $xmax = x if x > $xmax
    next if char == "."

    grid[V[x, y - 1]] << char
  end
end

def draw(grid)
  puts
  (0..$ymax).each do |y|
    (0..$xmax).each do |x|
      cell = grid[V[x, y]]

      next print "." if cell.length.zero?
      next print cell.length if cell.length > 1

      print cell.first
    end
    print "\n"
  end
end

# draw storms

def move_storms(grid)
  new_grid = Hash.new { |h, k| h[k] = [] }
  grid.each do |v, storms|
    storms.each do |dir|
      case dir
      when "<"
        pos = v + V[-1, 0]
        pos[X] = $xmax if pos[X] == -1
      when ">"
        pos = v + V[1, 0]
        pos[X] = 0 if pos[X] == $xmax + 1
      when "^"
        pos = v + V[0, -1]
        pos[Y] = $ymax if pos[Y] == -1
      when "v"
        pos = v + V[0, 1]
        pos[Y] = 0 if pos[Y] == $ymax + 1
      end

      new_grid[pos] << dir
    end
  end
  new_grid
end

DIRECTIONS = [
  V[0, -1],
  V[0, 1],
  V[-1, 0],
  V[1, 0]
].freeze

END_POS = V[$xmax, $ymax + 1]
START_POS = V[0, -1]

def visit(pos, grid)
  [pos, *DIRECTIONS.map { pos + _1 }]
    .reject do |p|
      next false if p == START_POS
      return [END_POS] if p == END_POS

      p[Y] < 0 || p[Y] > $ymax
    end
    .reject { grid[_1].any? }
    .reject { _1[X] < 0 || _1[X] > $xmax }
end

positions = Hash.new do |h, k|
  pp k
  h[k] = move_storms(h[k - 1])
end
positions[0] = grid

queues = [Set.new([START_POS])]
min = 0

catch(:done) do
  loop do
    queue = queues[min]
    queue.each do |pos|
      new_positions = visit(pos, positions[min])

      queues[min + 1] ||= Set.new
      new_positions.each do |p|
        throw :done if p == END_POS

        queues[min + 1] << p
      end
    end
    min += 1
  end
end

puts
pp min
