# frozen_string_literal: true

ARGF.read
  .split(/\n/)
  .map { _1.gsub(/[^\d]/, "") }
  .map { [_1[0], _1[-1]].join("").to_i }
  .sum
  .then { puts _1 }
