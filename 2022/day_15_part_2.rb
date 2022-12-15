# frozen_string_literal: true

# 34 seconds 😞

require "matrix"

class Range
  # From rails
  def overlaps?(other)
    cover?(other.first) || other.cover?(first)
  end

  def merge(other)
    Range.new([self.begin, other.begin].min, [self.end, other.end].max)
  end
end

data = $stdin.read

$sensors = []
max_y = 0

def distance(v1, v2)
  (v1[0] - v2[0]).abs + (v1[1] - v2[1]).abs
end

data.each_line(chomp: true) do |line|
  sx, sy, bx, by = line.match(
    /Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)/
  ).captures.map(&:to_i)

  s = Vector[sx, sy]
  b = Vector[bx, by]

  max_y = sy if sy > max_y
  max_y = by if by > max_y

  $sensors << [s, b, distance(s, b)]
end

def cover(sensor, y)
  s, _, max_d = sensor

  dy = (s[1] - y).abs
  if s[1] + max_d + 1 < y
    # Drop unneeded sensor
    $sensors.delete(sensor)
    return nil
  end
  return nil if dy > max_d

  dx = max_d - dy

  (s[0] - dx..s[0] + dx)
end

def ranges(y)
  $sensors
    .map { cover(_1, y) }
    .compact
    .sort do |a, b|
      start = a.begin - b.begin
      start == 0 ? a.end - b.end : start
    end
    .each_with_object([]) do |r, combined|
      if combined.last&.overlaps?(r)
        last = combined.pop
        combined << last.merge(r)
        next
      end

      combined << r
    end
end

beacon = (0..(max_y > 100 ? 4_000_000 : 20)).reduce do |_, y|
  ranges = ranges(y)
  pp ranges
  break [ranges.first.end + 1, y] if ranges.length > 1
end

pp beacon[0] * 4_000_000 + beacon[1]
