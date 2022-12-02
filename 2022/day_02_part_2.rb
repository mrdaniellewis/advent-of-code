# frozen_string_literal: true

data = $stdin.read

SCORES = {
  "A X" => 0 + 3, # lose R + S
  "A Y" => 3 + 1, # draw R + R
  "A Z" => 6 + 2, # win  R + P
  "B X" => 0 + 1, # lose P + R
  "B Y" => 3 + 2, # draw P + P
  "B Z" => 6 + 3, # win  P + S
  "C X" => 0 + 2, # lose S + P
  "C Y" => 3 + 3, # draw S + S
  "C Z" => 6 + 1  # win  S + R
}

puts data.split("\n").map { SCORES[_1] }.sum
