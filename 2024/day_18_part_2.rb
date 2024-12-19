# frozen_string_literal: true

require "matrix"
V = Vector
X = 0
Y = 1

bytes = ARGF.read.each_line.map(&:chomp).map do |line|
  x, y = line.scan(/\d+/).map(&:to_i)
  V[x, y]
end

X_RANGE = 0..(bytes.length == 25 ? 6 : 70)
Y_RANGE = 0..(bytes.length == 25 ? 6 : 70)
START = V[0, 0]
FINISH = V[X_RANGE.max, Y_RANGE.max]

DIRECTIONS = {
  V[0, 1] => "v",
  V[1, 0] => ">",
  V[0, -1] => "^",
  V[-1, 0] => "<"
}

def draw_grid(grid)
  print(Y_RANGE.map do |y|
    X_RANGE.map do |x|
      grid.include?(V[x, y]) ? "#" : "."
    end.join("")
  end.join("\n") + "\n\n")
end

class MinPriorityQueue
  QueueItem = Data.define(:item, :cost)

  def initialize
    @list = []
  end

  def push(cost:, value:)
    @list.insert(@list.find_index { _1.cost > cost } || -1, QueueItem.new(value, cost))
  end

  def next
    raise StopIteration if @list.empty?

    @list.shift.item
  end
end

class BreadthFirst
  attr_reader :nodes

  Edge = Data.define(:from, :to, :cost)
  Node = Data.define(:cost, :parents)
  VISITED = true

  def initialize(nodes)
    @nodes = nodes
  end

  def build(start)
    graph[start] = Node.new(0, [])
    queue.push(cost: 0, value: start)
    loop do
      position = queue.next
      enum = edges(position).to_enum
      loop do
        edge = enum.next
        visit(edge)
      end
    end

    graph
  end

  private

  def visit(edge)
    edge => { cost: }
    graph[edge.from] => { cost: parent_total }
    total = cost + parent_total
    queue.push(cost: total, value: edge.to) unless graph.key?(edge.to)
    graph[edge.to] => { cost: current_cost, parents: }
    graph[edge.to] = Node.new(total, parents | [edge.from]) if current_cost > total
  end

  def graph
    @graph ||= Hash.new { Node.new(Float::INFINITY, Set.new) }
  end

  def queue
    @queue ||= MinPriorityQueue.new
  end

  def edges(from)
    return [] if from == FINISH

    DIRECTIONS.keys.filter_map do |dir|
      to = from + dir
      next unless X_RANGE.include?(to[X])
      next unless Y_RANGE.include?(to[Y])
      next if nodes.include?(to)

      Edge.new(from, to, 1)
    end
  end
end

grid = Set.new(bytes)

draw_grid(grid)

bytes
  .reverse
  .find do |byte|
    grid.delete(byte)
    nodes = BreadthFirst.new(grid).build(START)
    draw_grid(grid)

    nodes.key?(FINISH) ? true : false
  end
  .then { puts _1.to_a.join(",") }
