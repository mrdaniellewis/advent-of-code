# frozen_string_literal: true

require "debug"
require "matrix"
V = Vector

BOULDERS = Set.new
grid = Set.new
ARGF.each_line.map(&:chomp).each_with_index do |line, y|
  line.chars.each_with_index do |char, x|
    BOULDERS << V[x, y] if char == "#"
    grid << V[x, y] if char == "O"
  end
end

def debug(grid)
  xrange = Range.new(*grid.map { _1[0] }.minmax)
  Range.new(*grid.map { _1[1] }.minmax).map do |y|
    xrange.map do |x|
      if BOULDERS.include?(V[x, y]) then "#"
      elsif grid.include?(V[x, y]) then "O"
      else
        "."
      end
    end.join("")
  end.join("\n")
end

# hmmmm, slow, probably should start at the lower side and move in a single loop
def tilt(grid, dir, axis, max)
  loop do
    modified = false
    grid = Set.new(grid.map) do |k|
      next k if k[axis] == max

      pos = k + dir
      next k if grid.include?(pos) || BOULDERS.include?(pos)

      modified = true
      pos
    end

    break unless modified
  end
  grid
end

def load(grid)
  ymax = grid.map { _1[1] }.max
  grid.map do |k|
    ymax - k[1] + 1
  end.sum
end

cycles = 0
xmin, xmax = grid.map { _1[0] }.minmax
ymin, ymax = grid.map { _1[1] }.minmax
DIRECTIONS = [[V[0, -1], 1, ymin], [V[-1, 0], 0, xmin], [V[0, 1], 1, ymax], [V[1, 0], 0, xmax]]

history = {}

module Enumerable
  # Find the start and length of a cycle using floyd
  def find_cycle_floyd
    hare_enum = to_enum
    tortoise_enum = to_enum
    hare = nil
    return nil unless loop do
      tortoise = tortoise_enum.next
      hare_enum.next
      hare = hare_enum.next
      break true if hare == tortoise
    end

    i = 0
    tortoise_enum = to_enum
    tortoise = nil
    until tortoise == hare
      hare = hare_enum.next
      tortoise = tortoise_enum.next
      i += 1
    end

    len = 1
    hare = tortoise_enum.next
    until tortoise == hare
      hare = tortoise_enum.next
      len += 1
    end

    [i - 1, len]
  rescue StopIteration
    nil
  end
end

history = []
cycle = nil

loop do
  cycles += 1

  grid = DIRECTIONS.reduce(grid) { |v, (dir, axis, max)| tilt(v, dir, axis, max) }
  history.unshift([debug(grid), grid])

  pp cycles
  break if (cycle = history.map(&:first).find_cycle_floyd)
end

_, repeat_length = cycle
left = 1_000_000_000 - cycles
shift = left % repeat_length

pp load(history[repeat_length - shift][1])
