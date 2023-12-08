# frozen_string_literal: true

games = ARGF.read.split("\n").to_h do |line|
  num, plays = /^Game (\d+): (.*)$/.match(line).captures
  plays = plays.split("; ").map do |draws|
    draws.split(", ").to_h do |draw|
      count, colour = /^(\d+) (.*)$/.match(draw).captures
      [colour.to_sym, count.to_i]
    end
  end
  [num.to_i, plays]
end

games
  .values
  .map do |plays|
    bag = { red: 0, green: 0, blue: 0 }
    plays.flatten.each do |draws|
      draws.each do |(k, v)|
        bag[k] = v if bag[k] < v
      end
    end
    bag
  end
  .map { _1.values.reduce(:*) }
  .sum
  .then { puts _1 }
