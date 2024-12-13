# frozen_string_literal: true

require "matrix"
V = Vector

MAP = ARGF.read.each_line.map(&:chomp).map.with_index do |line, y|
  line.chars.filter_map.with_index do |c, x|
    next if c == "."

    [V[x, y], c.to_i]
  end
end.flatten(1).to_h

Y_RANGE = 0..MAP.keys.max_by { _1[1] }[1]
X_RANGE = 0..MAP.keys.max_by { _1[0] }[0]

DIRECTIONS = [V[1, 0], V[0, 1], V[-1, 0], V[0, -1]]

def draw_grid(visited = MAP.keys)
  print(Y_RANGE.map do |y|
    X_RANGE.map do |x|
      visited.include?(V[x, y]) ? MAP[V[x, y]] : "."
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
    nodes[edge.to] == 9
  end

  def allowed?(edge)
    @visited ||= []
    @summitted ||= []
    return false if @visited.include?(edge)
    return false if @summitted.include?(edge.to)

    @visited << edge
    @summitted << edge.to if nodes[edge.to] == 9
    true
  end

  def paths(start)
    Enumerator.new do |y|
      position = start
      stack = [[[], edge_enumerator(position)]]
      loop do
        break if stack.empty?

        path, edges = stack.last
        edge = edges.next

        if !allowed?(edge)
          next
        elsif finish?(edge)
          y << [*path, edge]
        else
          stack << [[*path, edge], edge_enumerator(edge.to)]
        end
      rescue StopIteration
        stack.pop
      end
    end
  end

  def edge_enumerator(from)
    DIRECTIONS.filter_map do |dir|
      to = from + dir
      next unless nodes.key?(to)

      cost = nodes[to] - nodes[from]
      next unless cost == 1

      Edge.new(from, to, cost)
    end.to_enum
  end
end

MAP
  .filter { |_, v| v == 0 }
  .keys
  .map { DepthFirst.new(MAP).paths(_1).to_a }
  .map(&:length)
  .sum
  .then { p _1 }
