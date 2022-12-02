# frozen_string_literal: true

data = $stdin.read

PLAYS = {
  "X" => "R",
  "Y" => "P",
  "Z" => "S",
  "A" => "R",
  "B" => "P",
  "C" => "S"
}

SCORES = {
  %w[R R] => 3 + 1,
  %w[R P] => 6 + 2,
  %w[R S] => 0 + 3,
  %w[P R] => 0 + 1,
  %w[P P] => 3 + 2,
  %w[P S] => 6 + 3,
  %w[S R] => 6 + 1,
  %w[S P] => 0 + 2,
  %w[S S] => 3 + 3
}

score = data.split("\n")
            .map do |line|
              plays = line.split(" ").map { PLAYS[_1] }
              SCORES[plays]
            end

puts score.sum
