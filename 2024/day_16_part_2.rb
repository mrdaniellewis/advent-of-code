# frozen_string_literal: true

require "debug"
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

def draw_grid(highlight)
  print(Y_RANGE.map do |y|
    X_RANGE.map do |x|
      next "O" if highlight.include?(V[x, y])

      GRID.include?(V[x, y]) ? "#" : "."
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
    graph[edge.to] => { cost: current_cost, parents: current_parents}
    parents = [edge.from]
    parents |= current_parents if current_cost == total
    graph[edge.to] = Node.new(total, parents) if current_cost >= total
  end

  def graph
    @graph ||= Hash.new { Node.new(Float::INFINITY, Set.new) }
  end

  def queue
    @queue ||= MinPriorityQueue.new
  end

  def edges(from)
    return [] if from.position == FINISH

    DIRECTIONS.keys.filter_map do |dir|
      to = Position.new(from.position + dir, dir)
      next unless allowed?(from, to)

      Edge.new(from, to, cost(from, to))
    end
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

BreadthFirst.new(GRID).build(Position.new(START, V[1, 0])).then do |graph|
  min = graph.select { _1.position == FINISH }.values.map(&:cost).min
  queue = graph
    .select { |k, v| k.position == FINISH && v.cost == min }
    .values
    .map(&:parents)
    .map(&:to_a)
    .inject(:|)

  positions = Set.new([FINISH, *queue.map(&:position)])
  loop do
    break if queue.empty?

    graph[queue.pop].parents.each do |p|
      positions << p.position
      queue << p
    end
  end
  pp positions.uniq.length
end
