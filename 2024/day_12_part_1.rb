# frozen_string_literal: true

require "matrix"
V = Vector

MAP = ARGF.read.each_line.map(&:chomp).map.with_index do |line, y|
  line.chars.filter_map.with_index do |c, x|
    [V[x, y], c]
  end
end.flatten(1).to_h

Y_RANGE = 0..MAP.keys.max_by { _1[1] }[1]
X_RANGE = 0..MAP.keys.max_by { _1[0] }[0]

DIRECTIONS = [V[1, 0], V[0, 1], V[-1, 0], V[0, -1]]

def draw_grid(plot = MAP)
  print(Y_RANGE.map do |y|
    X_RANGE.map do |x|
      plot.include?(V[x, y]) ? MAP[V[x, y]] : "."
    end.join("")
  end.join("\n") + "\n\n")
end

class Plots
  attr_reader :nodes

  Edge = Data.define(:from, :to, :memo)

  def initialize(nodes)
    @nodes = nodes
  end

  def paths
    Enumerator.new do |y|
      queue = [nodes.keys.first]
      visited = Set.new
      loop do
        queue.uniq!
        queue.reject! { visited.include?(_1) }
        break if queue.empty?

        plot_queue = [queue.pop]
        plot = []
        loop do
          break if plot_queue.empty?

          position = plot_queue.pop
          visited << position
          plot << position
          edge_enumerator(position).each do |edge|
            next if visited.include?(edge.to)

            if edge.memo == nodes[position]
              plot_queue << edge.to
              plot << edge.to
              visited << edge.to
            else
              queue << edge.to
            end
          end
        end

        y << plot.uniq
      end
    end
  end

  def edge_enumerator(from)
    DIRECTIONS.filter_map do |dir|
      to = from + dir
      next unless nodes.key?(to)

      Edge.new(from, to, nodes[to])
    end.to_enum
  end
end

Plots
  .new(MAP)
  .paths
  .to_a
  .map do |plot|
    perimeter = plot.map do |position|
      DIRECTIONS.count do |dir|
        !plot.include?(position + dir)
      end
    end.sum
    [perimeter, plot.count]
  end
  .map { _1.reduce(:*) }
  .sum
  .then { p _1 }
