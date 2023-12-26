# frozen_string_literal: true

require "debug"
edges = Set[]

ARGF.each_line.map(&:chomp).each do |line|
  from, to = line.split(": ")

  to.split(" ").each do |t|
    edges << Set[from, t]
  end
end

# Karger
def contraction(edges, count)
  edges = edges.dup
  loop do
    edge = edges.sample
    edges.delete(edge)
    e1, e2 = edge.to_a

    new_edge = Set[*e1, *e2]

    edges.map! do |e|
      next e unless e.intersect?(edge)

      n1, n2 = e.to_a
      n1 = new_edge if edge.include?(n1)
      n2 = new_edge if edge.include?(n2)
      Set[n1, n2]
    end

    count -= 1
    break if count == 0
  end

  pp edges.size
  edges
end

edge_sets = edges.to_a.map do |e|
  a, b = e.to_a
  Set[Set[a], Set[b]]
end
size ||= Set[*edges.flat_map(&:to_a)].size
optimised = size - (size / Math.sqrt(2)).floor

loop do
  first = contraction(edge_sets, optimised)
  # Karger–Stein optimisation
  found = contraction(first, size - optimised - 2)
  if found.size == 3
    pp found.first.map(&:size).reduce(:*)
    break
  end
  found = contraction(first, size - optimised - 2)
  if found.size == 3
    pp found.first.map(&:size).reduce(:*)
    break
  end
end
