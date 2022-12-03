# frozen_string_literal: true

data = $stdin.read

result = data
  .split("\n")
  .each_slice(3)
  .to_a
  .flat_map { _1.map(&:chars).reduce(:&) }
  .map(&:ord)
  .map { _1 >= 97 ? _1 - 96 : _1 - 38 }
  .sum

puts result.inspect
