# frozen_string_literal: true

stones = ARGF.read.strip.split(" ").map(&:to_i)

25.times do
  stones = stones.flat_map do |stone|
    next 1 if stone.zero?

    digits = stone.to_s
    length = digits.length
    next digits.chars.each_slice(length / 2).to_a.map(&:join).map(&:to_i) if length.even?

    stone * 2024
  end
end

pp stones.length
