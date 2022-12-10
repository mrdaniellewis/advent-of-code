# frozen_string_literal: true

data = $stdin.read

program = data.each_line(chomp: true).flat_map do |line|
  command, count = line.scan(/^(\w+)(?: (-?\d+))?/)[0]
  next [0] if command == "noop"

  [0, count.to_i]
end

$x = 1

execution = program.map do |addx|
  $x += addx
  $x
end

strength = [20, 60, 100, 140, 180, 220].map do |cycle|
  # Need value on previous cycle
  execution[cycle - 2] * cycle
end.sum

pp strength
