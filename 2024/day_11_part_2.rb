# frozen_string_literal: true

stones = ARGF.read.strip.split(" ").map(&:to_i).tally

75.times do
  stones = stones.each_with_object(Hash.new { 0 }) do |(stone, count), new_stones|
    next new_stones[1] += count if stone.zero?

    digits = stone.to_s
    length = digits.length
    next new_stones[stone * 2024] += count if length.odd?

    new_stones[digits[0...length / 2].to_i] += count
    new_stones[digits[length / 2..].to_i] += count
  end.to_h
end

pp stones.values.sum
