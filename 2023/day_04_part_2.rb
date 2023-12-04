# frozen_string_literal: true

data = ARGF.read

Card = Struct.new(:card, :winning, :having, :number)

cards = data.split("\n").to_h do |line|
  card, winning, having = /^Card\s+(\d+):([^|]+)\|(.+)$/.match(line).captures

  [card.to_i, Card.new(
    card: card.to_i,
    winning: winning.strip.split(/\s+/).map(&:to_i),
    having: having.strip.split(/\s+/).map(&:to_i),
    number: 1
  )]
end

cards.each do |num, card|
  (1..card.having.select { card.winning.include?(_1) }.length).each do |i|
    cards[num + i].number += card.number
  end
end

pp cards.values.map(&:number).sum
