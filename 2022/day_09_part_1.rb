# frozen_string_literal: true

require "matrix"

data = $stdin.read

DIRECTIONS = {
  "R" => Vector[0, 1],
  "L" => Vector[0, -1],
  "U" => Vector[-1, 0],
  "D" => Vector[1, 0]
}

instructions = data.each_line(chomp: true).flat_map do |line|
  direction, count = line.scan(/(\w) (\d+)/)[0]
  Array.new(count.to_i, DIRECTIONS[direction])
end

$head = Vector[0, 0]
$tail = Vector[0, 0]

def debug
  puts
  puts((-5..0).map do |y|
    (0...6).map do |x|
      next "H" if Vector[y, x] == $head
      next "T" if Vector[y, x] == $tail

      "."
    end.join
  end.join("\n"))
end

track = instructions.map do |v|
  $head = $head + v
  diff = $head - $tail
  $tail = $tail + diff.map { _1.clamp(-1, 1) } if diff.any? { _1.abs >= 2 }
  $tail
end

pp track.uniq.size
