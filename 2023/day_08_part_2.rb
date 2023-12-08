# frozen_string_literal: true

require "prime"
instructions = nil
map = {}

ARGF.each_line.map(&:chomp).map do |line|
  next instructions = line.chars unless instructions
  next if line == ""

  name, left, right = /(\w{3}) = \((\w{3}), (\w{3})\)/.match(line).captures
  map[name] = { "L" => left, "R" => right }
end

locations = map.keys.select { _1.end_with?("A") }

intervals = locations.map do |location|
  steps = 0
  loop do
    location = map[location][instructions[steps % instructions.length]]
    steps += 1
    break if location.end_with?("Z")
  end
  steps
end

pp intervals.map { Prime.prime_division(_1) }.flatten.uniq.reduce(:*)
