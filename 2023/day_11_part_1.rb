# frozen_string_literal: true

require "matrix"

V = Vector

planets = []

ARGF.each_line.map(&:chomp).each_with_index do |line, y|
  line.chars.each_with_index do |c, x|
    planets << V[x, y] if c == "#"
  end
end

unexpanded = [
  Set.new(planets.map { _1[0] }.uniq),
  Set.new(planets.map { _1[1] }.uniq)
]

planets
  .combination(2)
  .to_a
  .map do |(p1, p2)|
    [0, 1].map do |coord|
      s, e = [p1[coord], p2[coord]].sort
      Range.new(s + 1, e).reduce(0) do |total, x|
        total + (unexpanded[coord].include?(x) ? 1 : 2)
      end
    end.sum
  end
  .sum
  .then { puts _1 }
