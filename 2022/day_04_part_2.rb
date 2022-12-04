# frozen_string_literal: true

data = $stdin.read

class Range
  # From rails
  def overlaps?(other)
    cover?(other.first) || other.cover?(first)
  end
end

result = data
  .split("\n")
  .map do |part|
    part1, part2 = part.split(",")
    r1 = Range.new(*part1.split("-").map(&:to_i))
    r2 = Range.new(*part2.split("-").map(&:to_i))
    r1.overlaps?(r2)
  end
  .filter(&:itself)
  .length

puts result.inspect
