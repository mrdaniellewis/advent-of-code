# frozen_string_literal: true

data = $stdin.read

result = data
  .split("\n")
  .map do |part|
    part1, part2 = part.split(",")
    r1 = Range.new(*part1.split("-").map(&:to_i))
    r2 = Range.new(*part2.split("-").map(&:to_i))
    r1.cover?(r2) || r2.cover?(r1)
  end
  .filter(&:itself)
  .length

puts result.inspect
