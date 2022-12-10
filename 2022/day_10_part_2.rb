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

output = (0...6).map do |line|
  (0...40).map do |char|
    pos = line * 40 + char - 1
    # Need value on the previous cycle
    x = pos >= 0 ? execution[pos] : 1
    next "#" if (x - 1...x + 2).include?(char)

    "."
  end.join
end.join("\n")

puts output
