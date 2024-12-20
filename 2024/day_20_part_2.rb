# frozen_string_literal: true

require "matrix"
V = Vector
X = 0
Y = 1

GRID = ARGF.read.each_line.map(&:chomp).flat_map.with_index do |line, y|
  line.chars.filter_map.with_index do |c, x|
    START = V[x, y] if c == "S"
    FINISH = V[x, y] if c == "E"
    V[x, y] if c == "#"
  end
end.then { Set.new(_1) }

Y_RANGE = 0..GRID.max_by { _1[1] }[1]
X_RANGE = 0..GRID.max_by { _1[0] }[0]
DIRECTIONS = [V[0, 1], V[1, 0], V[0, -1], V[-1, 0]]

def draw_grid(positions, cheats = Set.new)
  print(Y_RANGE.map do |y|
    X_RANGE.map do |x|
      next "X" if cheats.include?(V[x, y])
      next "O" if positions.include?(V[x, y])
      next "E" if V[x, y] == FINISH
      next "S" if V[x, y] == START

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
  Node = Data.define(:cost, :parents, :position)
  VISITED = true

  def initialize(nodes)
    @nodes = nodes
  end

  def build(start)
    graph[start] = Node.new(0, [], start)
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
    graph[edge.to] = Node.new(total, parents | [edge.from], edge.to) if current_cost > total
  end

  def graph
    @graph ||= Hash.new { Node.new(Float::INFINITY, Set.new, nil) }
  end

  def queue
    @queue ||= MinPriorityQueue.new
  end

  def edges(from)
    return [] if from == FINISH

    DIRECTIONS.filter_map do |dir|
      to = from + dir
      next if nodes.include?(to)

      Edge.new(from, to, 1)
    end
  end
end

nodes = BreadthFirst.new(GRID).build(START)

distance = (-20..20).to_a.repeated_permutation(2).select { _1.to_a.map(&:abs).sum <= 20 }

nodes
  .values
  .sort_by(&:cost)
  .map do |node|
    distance
      .filter_map do |(x, y)|
        dir = V[x, y]
        to = node.position + V[x, y]

        next unless nodes.include?(to)

        [to, dir]
      end
      .map do |(to, dir)|
        nodes[to].cost - nodes[node.position].cost - dir.to_a.map(&:abs).sum
      end
      .reject(&:negative?)
  end
  .flatten
  .tally
  .sort.to_h
  .select { |time| time >= 100 }
  .sum { |_, v| v }
  .then { p _1 }
