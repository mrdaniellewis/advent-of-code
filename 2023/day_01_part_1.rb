# frozen_string_literal: true

data = $stdin.read

data
  .split(/\n/)
  .map { _1.gsub(/[^\d]/, "") }
  .map { [_1[0], _1.reverse[0]].join("").to_i }
  .sum
  .then { puts _1 }
