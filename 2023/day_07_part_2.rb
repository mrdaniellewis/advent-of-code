# frozen_string_literal: true

Hand = Struct.new(:cards, :bid, :type)

hands = ARGF.each_line.map(&:chomp).map do |line|
  cards, bid = /([AKQJT2-9]{5}) (\d+)/.match(line).captures

  Hand.new(cards: cards.chars, bid: bid.to_i)
end

hands.each do |hand|
  groups = hand.cards.group_by(&:itself)

  jokers = groups.delete("J")&.length || 0
  groups = groups.values.map(&:length)
  max = groups.max || 0

  hand.type =
    if max + jokers == 5
      :five_of_kind
    elsif max + jokers == 4
      :four_of_kind
    elsif groups.length == 2
      :full_house
    elsif max + jokers == 3
      :three_of_kind
    elsif groups.select { _1 == 2 }.length == 2 || (groups.include?(2) && jokers == 1)
      :two_pair
    elsif max + jokers == 2
      :one_pair
    else
      :high_card
    end
end

HAND_ORDER = %i[five_of_kind four_of_kind full_house three_of_kind two_pair one_pair
                high_card].reverse.map.with_index.to_h
CARD_ORDER = %w[A K Q T 9 8 7 6 5 4 3 2 J].reverse.map.with_index.to_h

hands.sort_by! do |hand|
  [HAND_ORDER[hand.type], *hand.cards.map { CARD_ORDER[_1] }]
end

hands
  .map
  .with_index { |hand, i| hand.bid * (i + 1) }
  .sum
  .then { puts _1 }
