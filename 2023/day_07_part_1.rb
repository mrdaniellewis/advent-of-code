# frozen_string_literal: true

Hand = Struct.new(:cards, :bid, :type)

hands = ARGF.each_line.map(&:chomp).map do |line|
  cards, bid = /([AKQJT2-9]{5}) (\d+)/.match(line).captures

  Hand.new(cards: cards.chars, bid: bid.to_i)
end

hands.each do |hand|
  groups = hand.cards.group_by(&:itself).values.map(&:length)
  hand.type =
    if groups.size == 1
      :five_of_kind
    elsif groups.any? { _1 == 4 }
      :four_of_kind
    elsif groups.length == 2
      :full_house
    elsif groups.any? { _1 == 3 }
      :three_of_kind
    elsif groups.length == 3
      :two_pair
    elsif groups.any? { _1 == 2 }
      :one_pair
    else
      :high_card
    end
end

HAND_ORDER = %i[five_of_kind four_of_kind full_house three_of_kind two_pair one_pair
                high_card].reverse.map.with_index.to_h
CARD_ORDER = %w[A K Q J T 9 8 7 6 5 4 3 2].reverse.map.with_index.to_h

hands.sort_by! do |hand|
  [HAND_ORDER[hand.type], *hand.cards.map { CARD_ORDER[_1] }]
end

hands
  .map
  .with_index { |hand, i| hand.bid * (i + 1) }
  .sum
  .then { puts _1 }
