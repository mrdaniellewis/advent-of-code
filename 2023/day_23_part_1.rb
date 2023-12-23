# frozen_string_literal: true

require "Matrix"
V = Vector
X = 0
Y = 1

GRID = ARGF.each_line.map(&:chomp).each_with_object({}).with_index do |(line, h), y|
  line.chars.each_with_index do |char, x|
    h[V[x, y]] = char if char != "#"
  end
end

XRANGE = Range.new(0, GRID.keys.map { _1[X] }.max + 1)
YRANGE = Range.new(0, GRID.keys.map { _1[Y] }.max)
START = GRID.keys.find { _1[Y] == 0 }
FINISH = GRID.keys.find { _1[Y] == YRANGE.max }

def debug(route = [])
  YRANGE.to_a.map do |y|
    XRANGE.to_a.map do |x|
      pos = V[x, y]
      route.include?(pos) ? "O" : (GRID[pos] || "#")
    end.join("")
  end.join("\n") + "\n\n"
end

DIRECTIONS = [V[0, 1], V[1, 0], V[-1, 0], V[0, -1]]
SLOPES = {
  ">" => V[1, 0],
  "v" => V[0, 1],
  "<" => V[-1, 0],
  "^" => V[0, -1]
}

# Probably actually an acyclic graph and could just do a min distance dfs
# But this eventually gets the answer
stack = [Set[START]]
finished = []
loop do
  route = stack.pop
  pos = route.first
  DIRECTIONS.each do |dir|
    slope = SLOPES[GRID[pos]]
    next if slope && slope != dir

    new_pos = pos + dir
    next finished << Set[new_pos, *route] if new_pos == FINISH
    next unless GRID[new_pos]
    next if route.include?(new_pos)

    stack << Set[new_pos, *route]
  end

  break if stack.empty?
end

finished.map(&:size).map { _1 - 1 }.max.then { puts _1 }
