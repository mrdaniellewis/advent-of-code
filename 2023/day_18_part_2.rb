# frozen_string_literal: true

require "matrix"
V = Vector

Instruction = Data.define(:direction, :distance)

DIRECTIONS = [
  V[1, 0],
  V[0, 1],
  V[-1, 0],
  V[0, -1]
]

instructions = ARGF.each_line.map(&:chomp).map do |line|
  _, _, colour = /([RDLU]) (\d+) \(#([a-f0-9]{6})\)/.match(line).captures
  Instruction.new(DIRECTIONS[colour[5].to_i(16)], colour[0..4].to_i(16))
end

LEFT = Matrix[[0, 1], [-1, 0]]

# The inputs all start heading right and end heading up
cursor = V[0, 0]
coordinates = [V[0, 0]]
previous_direction = nil

instructions.each do |instruction|
  instruction => { direction:, distance: }

  if previous_direction
    left_start = LEFT * previous_direction + cursor
    left_turn = LEFT * direction + cursor

    # Find the common corner of the left facing tile in the
    # original direction and after the turn
    # This is out outside coordinate
    [left_start, left_turn]
      .map { |c| [c, c + V[1, 0], c + V[1, 1], c + V[0, 1]] }
      .reduce(&:intersection)
      .first
      .then { coordinates << _1 }
  end
  previous_direction = direction
  cursor += direction * distance
end

coordinates << V[0, 0]

# Shoelace formula
coordinates
  .each_cons(2)
  .map do |(a, b)|
    Matrix[[a[0], b[0]], [a[1], b[1]]]
  end
  .map(&:determinant)
  .reduce(:+)
  .then { puts _1 / 2 }
