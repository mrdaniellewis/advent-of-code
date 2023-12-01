# frozen_string_literal: true

require "matrix"
require "set"

V = Vector

data = $stdin.read

elfs = Set.new

P_N = [V[0, -1], [V[-1, -1], V[0, -1], V[1, -1]]].freeze
P_S = [V[0, 1], [V[-1, 1], V[0, 1], V[1, 1]]].freeze
P_W = [V[-1, 0], [V[-1, -1], V[-1, 0], V[-1, 1]]].freeze
P_E = [V[1, 0], [V[1, -1], V[1, 0], V[1, 1]]].freeze

directions = [P_N, P_S, P_W, P_E]

data.each_line(chomp: true).with_index do |line, y|
  line.chars.each_with_index do |char, x|
    elfs << V[x, y] if char == "#"
  end
end

def draw(grid)
  ymin, ymax = grid.map { _1[1] }.minmax
  xmin, xmax = grid.map { _1[0] }.minmax

  (ymin..ymax).each do |y|
    (xmin..xmax).each do |x|
      print(grid.include?(V[x, y]) ? "#" : ".")
    end
    print "\n"
  end
end

DIRECTIONS = ([-1, 0, 1].repeated_permutation(2).to_a - [[0, 0]]).map { V[_1[0], _1[1]] }.freeze

count = 0

loop do
  puts
  puts "count=#{count}"

  draw elfs

  break if count == 10

  proposals = Hash.new { |h, k| h[k] = [] }

  # Find proposals
  elfs.each do |v|
    next if DIRECTIONS.none? { elfs.include?(v + _1) }

    prop = directions.find do |dir|
      dir[1].none? do |p|
        elfs.include?(v + p)
      end
    end

    proposals[v + prop[0]] << v if prop
  end

  # Move elfs
  proposals.each do |v, proposed|
    next unless proposed.length == 1

    # move elf
    elfs.delete(proposed[0])
    elfs << v
  end

  # rotate proposals
  directions << directions.shift

  count += 1
end

ymin, ymax = elfs.map { _1[1] }.minmax
xmin, xmax = elfs.map { _1[0] }.minmax

pp (ymax - ymin + 1) * (xmax - xmin + 1) - elfs.size
