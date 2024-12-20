# frozen_string_literal: true

TOWELS, PATTERNS = ARGF.read.each_line.map(&:chomp).each_with_object([[], []]) do |line, (t, p)|
  if line.include?(",")
    t.push(*line.split(",").map(&:strip)) if line.include?(",")
  elsif !line.empty?
    p << line
  end
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
  Edge = Data.define(:from, :to, :cost)
  Node = Data.define(:cost, :parents)
  VISITED = true

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
    graph[edge.to] = Node.new(total, parents | [edge.from])
  end

  def graph
    @graph ||= Hash.new { Node.new(Float::INFINITY, Set.new) }
  end

  def queue
    @queue ||= MinPriorityQueue.new
  end

  def edges(from)
    pattern, offset = from
    return [] if offset == pattern.length

    TOWELS
      .select do |t|
        i = pattern.index(t, offset)
        i == offset
      end
      .map do |t|
        Edge.new(from, [pattern, offset + t.length], 1)
      end
  end
end

TOWELS.sort_by!(&:length).reverse!

PATTERNS
  .map do |pattern|
    BreadthFirst
      .new
      .build([pattern, 0])
      .then do |nodes|
        nodes = nodes.to_h do |k, v|
          [k[0][0...k[1]], v.parents.map { _1[0][0..._1[1]] }]
        end

        inverse = nodes.keys.to_h do |n|
          [n, nodes.keys.select { nodes[_1].include?(n) }]
        end

        queue = [""]
        queue_counts = Hash.new { 0 }
        queue_counts[""] = 1

        loop do
          break if queue.empty?

          node = queue.shift
          inverse[node].each do |n|
            if queue_counts.key?(n)
              queue_counts[n] += queue_counts[node]
            else
              queue << n
              queue_counts[n] = queue_counts[node]
            end
          end
          queue.sort_by!(&:length)
        end

        queue_counts[pattern]
      end
  end
  .sum
  .then { pp _1 }
