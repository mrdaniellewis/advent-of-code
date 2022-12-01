# frozen_string_literal: true

require "byebug"

$player_1_position = DATA.readline[/starting position: (\d+)/, 1].to_i
$player_2_position = DATA.readline[/starting position: (\d+)/, 1].to_i

# Optimisation: Probably could cache these results to speed it up
def next_pos(pos, increment)
  pos -= 1
  pos += increment
  pos %= 10
  pos + 1
end

# Optimisation: Probably could cache these results to speed it up
def play(dice, player, pos)
  roll = player
  score = 0
  loop do
    return false if roll >= dice.length

    pos = next_pos(pos, dice[roll])
    score += pos
    return score if score >= 21

    roll += 2
  end
end

# Divide into triples
# [xxx] [yyy] [xxx] [yyy]
#
# We only care about the sum of the triple
# which are 1, 3, 6, 7, 6, 3, 1
# with frequencies
# { 3: 1, 4: 3, 5: 6, 6: 7, 7: 6, 8: 3, 9: 1 }

def plays(dice = [])
  Enumerator.new do |yielder|
    (3..9).each do |roll1|
      pp roll1 if dice == []
      p1_dice = [*dice, roll1]
      # Optimisation: Don't really need to start play from scratch each time
      result = play(p1_dice, 0, $player_1_position)
      if result
        yielder << [0, p1_dice]
        # Optimisation: Could also yield the remaining results for roll1 as these will all pass
      else
        (3..9).each do |roll2|
          p2_dice = [*p1_dice, roll2]
          result = play(p2_dice, 1, $player_2_position)
          if result
            yielder << [1, p2_dice]
            # Optimisation: Could also yield the remaining results for roll2 as these will all pass
          else
            plays(p2_dice).each do |d|
              yielder << d
            end
          end
        end
      end
    end
  end
end

$wins = [0, 0]

dist = {}
[1, 2, 3].repeated_permutation(3).each do |dice|
  dist[dice.sum] = (dist[dice.sum] || 0) + 1
end

plays([]).each do |(p, dice)|
  $wins[p] += dice.map { |die| dist[die] }.reduce(:*)
end

pp $wins.max

__END__
Player 1 starting position: 4
Player 2 starting position: 6
