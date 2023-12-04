# frozen_string_literal: true

data = $stdin.read

Card = Struct.new(:card, :winning, :having)

cards = data.split("\n").map do |line|
  card, winning, having = /^Card\s+(\d+):([^|]+)\|(.+)$/.match(line).captures

  Card.new(
    card: card.to_i,
    winning: winning.strip.split(/\s+/).map(&:to_i),
    having: having.strip.split(/\s+/).map(&:to_i)
  )
end

cards
  .map do |card|
    winners = card.having.select { card.winning.include?(_1) }.length
    next 0 if winners.zero?

    2**(winners - 1)
  end
  .sum
  .then { puts _1 }
