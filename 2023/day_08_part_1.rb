# frozen_string_literal: true

instructions = nil
map = {}

ARGF.each_line.map(&:chomp).map do |line|
  next instructions = line.chars unless instructions
  next if line == ""

  name, left, right = /(\w{3}) = \((\w{3}), (\w{3})\)/.match(line).captures
  map[name] = { "L" => left, "R" => right }
end

steps = 0
location = "AAA"
loop do
  location = map[location][instructions[steps % instructions.length]]
  steps += 1

  break if location == "ZZZ"
end

pp steps
