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
$tails = Array.new(9) { Vector[0, 0] }

def debug
  puts
  puts((-10..10).map do |y|
    (-10..10).map do |x|
      next "H" if Vector[y, x] == $head

      index = $tails.find_index { _1 == Vector[y, x] }
      next index + 1 if index

      "."
    end.join
  end.join("\n"))
end

track = instructions.map do |v|
  $head = $head + v
  $tails.each_with_index do |tail, index|
    diff = (index.zero? ? $head : $tails[index - 1]) - tail
    $tails[index] = tail + diff.map { _1.clamp(-1, 1) } if diff.any? { _1.abs >= 2 }
  end
  $tails.last
end

pp track.uniq.size
