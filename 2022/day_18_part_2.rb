# frozen_string_literal: true

require "matrix"
require "set"

data = $stdin.read

CUBES = Set.new(data.each_line(chomp: true).map do |line|
  Vector[*line.split(",").map(&:to_i)]
end)

SIDES = [
  Vector[1, 0, 0],
  Vector[0, 1, 0],
  Vector[0, 0, 1],
  Vector[-1, 0, 0],
  Vector[0, -1, 0],
  Vector[0, 0, -1]
]

edges = Hash.new { |h, k| h[k] = 0 }

CUBES.each do |cube|
  SIDES.each do |side|
    edges[cube + side] += 1
  end
end

edges = edges.reject { |k| CUBES.include?(k) }

def free_dir?(pos, dir)
  coord = dir.find_index { _1 != 0 }
  neg = dir[coord] == -1

  CUBES.none? do |cube|
    3.times.all? do |c|
      if coord == c
        if neg
          cube[c] < pos[c]
        else
          cube[c] > pos[c]
        end
      else
        cube[c] == pos[c]
      end
    end
  end
end

free_edges = Set.new
edge_queues = {}
known = edges.keys
queue = edges.keys

loop do
  edge = queue.shift
  break if edge.nil?

  free = SIDES.any? do |dir|
    free_edges.include?(edge + dir) || free_dir?(edge, dir)
  end

  free_edges << edge if free

  next if free

  SIDES.each do |dir|
    e = edge + dir
    next if CUBES.include?(e)

    # Unknown add to a queue for that edge
    edge_queues[e] ||= []
    edge_queues[e] << edge

    queue << edge unless known.include?(edge)
  end
end

loop do
  new_free = free_edges.flat_map do |edge|
    edge_queues.delete(edge) || []
  end

  break if new_free.empty?

  new_free.each { free_edges << _1 }
end

pp edges.select { |k| free_edges.include?(k) }.values.sum
