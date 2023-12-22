# frozen_string_literal: true

require "matrix"
require "debug"
V = Vector
X = 0
Y = 1
Z = 2

class Range
  def overlaps?(other)
    cover?(other.first) || other.cover?(first)
  end
end

name = ("A"..).to_enum

class Brick
  attr_reader :name, :start, :finish

  def initialize(start, finish, name: nil)
    @name = name
    @start = start
    @finish = finish
  end

  def coords
    [start, finish]
  end

  def in_plane?(a, v)
    axis(a).include?(v)
  end

  def axis(a)
    start[a]..finish[a]
  end

  def overlaps?(brick)
    [X, Y, Z].all? do |a|
      axis(a).overlaps?(brick.axis(a))
    end
  end

  def slice(a, v)
    new_start = start.dup
    new_finish = finish.dup
    new_start[a] = v
    new_finish[a] = v

    Brick.new(new_start, new_finish)
  end

  def min(a)
    start[a]
  end

  def max(a)
    finish[a]
  end

  def minmax(a)
    [start[a], finish[a]]
  end

  def move(a, v)
    move = V[0, 0, 0]
    move[a] = v
    @start += move
    @finish += move
  end

  def inspect
    name
  end
end

bricks = ARGF.each_line.map(&:chomp).map do |line|
  min, max = line.split("~")
  Brick.new(
    V[*min.split(",").map(&:to_i)],
    V[*max.split(",").map(&:to_i)],
    name: name.next
  )
end

bottomindex = []
topindex = []
bricks.each do |brick|
  min, max = brick.minmax(Z)

  bottomindex[min] ||= Set.new
  bottomindex[min] << brick
  topindex[max] ||= Set.new
  topindex[max] << brick
end

def debug(bricks, axis)
  zrange = Range.new(*bricks.map(&:coords).flatten.map { _1[Z] }.minmax)
  range = Range.new(*bricks.map(&:coords).flatten.map { _1[axis] }.minmax)

  zrange.to_a.reverse.map do |z|
    range.to_a.map do |i|
      bricks.find { _1.in_plane?(Z, z) && _1.in_plane?(axis == X ? Y : X, i) }&.name&.chars&.first || "."
    end.join("")
  end.join("\n") + "\n\n"
end

cursor = 2
until cursor >= bottomindex.length
  current = bottomindex[cursor]
  current&.each do |brick|
    loop do
      break if brick.in_plane?(Z, 1)

      min = brick.min(Z) - 1
      below = brick.slice(Z, min)
      supported = topindex[min]&.to_a&.find do |b|
        b.overlaps?(below)
      end
      break if supported

      pmin, pmax = brick.minmax(Z)
      brick.move(Z, -1)
      bmin, bmax = brick.minmax(Z)
      bottomindex[pmin].delete(brick)
      bottomindex[bmin] ||= Set.new
      bottomindex[bmin] << brick

      topindex[pmax].delete(brick)
      topindex[bmax] ||= Set.new
      topindex[bmax] << brick
    end
  end

  cursor += 1
end

supports = Hash.new { [] }
supported_by = Hash.new { [] }

bricks
  .each do |brick|
    above = brick.slice(Z, brick.max(Z) + 1)
    s = bricks.filter do |b|
      b.overlaps?(above)
    end
    supports[brick] = s
    s.each do |b|
      supported_by[b] += [brick]
    end
  end

fall_cache = {}

bricks.sort_by! { _1.min(Z) }.reverse!

bricks
  .map do |brick|
    falling = Set[brick]
    check = supports[brick]
    loop do
      check = check
        .flat_map do |b|
          s = supported_by[b]
          if (s - falling.to_a - [b]).empty?
            falling << b
            if fall_cache.include?(b)
              fall_cache[b].flat_map do |f|
                falling << f
                supports[f]
              end
            else
              supports[b]
            end
          else
            []
          end
        end

      check -= falling.to_a
      break if check.empty?
    end
    fall_cache[brick] = falling
    falling.size - 1
  end
  .sum
  .then { pp _1 }
