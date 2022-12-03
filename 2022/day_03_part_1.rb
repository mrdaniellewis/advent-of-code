# frozen_string_literal: true

data = $stdin.read

result = data
  .split("\n")
  .flat_map do
    first, second = _1.chars.each_slice(_1.length / 2).to_a
    first & second
  end
  .map(&:ord)
  .map { _1 >= 97 ? _1 - 96 : _1 - 38 }
  .sum

puts result
