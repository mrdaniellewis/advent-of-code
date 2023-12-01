# frozen_string_literal: true

data = $stdin.read

DIGITS = %w[
  zero one two three four five six seven eight nine
]

R_DIGITS = Regexp.new("(?=(#{Regexp.union(*DIGITS, /\d/)}))")

data
  .split(/\n/)
  .map { _1.scan(R_DIGITS).flatten }
  .map { _1.map { |d| DIGITS.index(d) || d } }
  .map { [_1.first, _1.last].join("").to_i }
  .sum
  .then { puts _1 }
