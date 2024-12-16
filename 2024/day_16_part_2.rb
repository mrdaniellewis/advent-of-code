# frozen_string_literal: true

require "matrix"
V = Vector

GRID = ARGF.read.each_line.map(&:chomp).flat_map.with_index do |line, y|
  line.chars.filter_map.with_index do |c, x|
    START = V[x, y] if c == "S"
    FINISH = V[x, y] if c == "E"
    V[x, y] if c == "#"
  end
end.then { Set.new(_1) }

Y_RANGE = 0..GRID.max_by { _1[1] }[1]
X_RANGE = 0..GRID.max_by { _1[0] }[0]
DIRECTIONS = {
  V[0, 1] => "v",
  V[1, 0] => ">",
  V[0, -1] => "^",
  V[-1, 0] => "<"
}

Position = Data.define(:position, :direction)

def draw_grid(positions)
  indexed = positions.to_h { [_1.position, _1] }
  print(Y_RANGE.map do |y|
    X_RANGE.map do |x|
      pos = indexed[V[x, y]]
      next DIRECTIONS[pos.direction] if pos

      GRID.include?(V[x, y]) ? "#" : "."
    end.join("")
  end.join("\n") + "\n\n")
end

class DepthFirst
  attr_reader :nodes

  Edge = Data.define(:from, :to, :cost)

  def initialize(nodes)
    @nodes = nodes
  end

  def finish?(edge)
    edge.to.position == FINISH
  end

  def paths(start)
    Enumerator.new do |y|
      position = start
      stack = [[[], edge_enumerator(position), 0]]
      best_costs = Hash.new { Float::INFINITY }
      best_cost = Float::INFINITY
      loop do
        break if stack.empty?

        path, edges, current_cost = stack.last
        edge = edges.next
        current_cost += edge.cost
        next stack.pop if best_cost < current_cost

        current_best = best_costs[edge]
        next stack.pop if current_best < current_cost

        best_costs[edge] = current_cost

        if finish?(edge)
          best_cost = current_cost
          y << [[start, *path.map(&:to), edge.to], current_cost]
        else
          stack << [[*path, edge], edge_enumerator(edge.to), current_cost]
        end
      rescue StopIteration
        stack.pop
      end
    end
  end

  def edge_enumerator(from)
    DIRECTIONS.keys.filter_map do |dir|
      to = Position.new(from.position + dir, dir)
      next unless allowed?(from, to)

      Edge.new(from, to, cost(from, to))
    end.sort_by(&:cost).to_enum
  end

  def allowed?(from, to)
    return false if nodes.include?(to.position)
    return false if (from.direction + to.direction).magnitude.zero?

    true
  end

  def cost(from, to)
    1 + (from.direction == to.direction ? 0 : 1000)
  end
end

DepthFirst
  .new(GRID)
  .paths(Position.new(START, V[1, 0]))
  .to_a
  .then do |found|
    min = found.map { _1[1] }.min
    found.select { _1[1] == min }
  end
  .map { _1[0] }
  .flatten
  .map(&:position)
  .uniq
  .then { p _1.count }
