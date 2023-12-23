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

# Reduce the problem to a graph

verticies = { START => {}, FINISH => {} }
heap = [[[START, V[1, 1]], V[1, 1]]]

loop do
  route, pos = heap.pop

  directions = DIRECTIONS
    .map { pos + _1 }
    .select { GRID[_1] }

  if directions.size == 2
    # path
    new_pos = (directions - route).first
    route << new_pos
    heap << [route, new_pos]
  else
    verticies[route.first][pos] = route.length - 1
    verticies[pos][route.first] = route.length - 1 if pos == FINISH

    unless verticies.key?(pos)
      verticies[pos] ||= {}
      directions.each do |p|
        heap << [[pos, p], p]
      end
    end
  end

  break if heap.empty?
end

# Do a depth first search prioritising the longest paths
# Probably the result will pop out

def df(verticies, start, finish)
  Enumerator.new do |y|
    stack = [[[start], 0]]

    until stack.empty?
      route, total = stack.pop
      pos = route.last
      y << [route, total] if pos == finish

      verticies[pos]
        .select { GRID[_1] }
        .reject { route.include?(_1) }
        .sort_by { _2 }
        .each do |(new_pos, d)|
          stack << [[*route, new_pos], total + d]
        end
    end
  end
end

max = 0

df(verticies, START, FINISH).each do |a|
  if a[1] > max
    pp a[1]
    max = a[1]
  end
end
