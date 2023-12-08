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

BAG = {
  red: 12,
  green: 13,
  blue: 14
}

games
  .select do |_num, plays|
    plays.all? do |play|
      BAG.all? do |(k, v)|
        (play[k] || 0) <= v
      end
    end
  end
  .keys
  .sum
  .then { puts _1 }
