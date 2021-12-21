# frozen_string_literal: true

player_1_position = DATA.readline[/starting position: (\d+)/, 1].to_i
player_2_position = DATA.readline[/starting position: (\d+)/, 1].to_i

$dice = 99
$rolls = 0
player_1_score = 0
player_2_score = 0

def roll
  $rolls += 1
  $dice += 1
  $dice %= 100
  $dice + 1
end

def next_pos(pos, increment)
  pos -= 1
  pos += increment
  pos %= 10
  pos + 1
end

loop do
  player_1_position = next_pos(player_1_position, roll + roll + roll)
  player_1_score += player_1_position
  break if player_1_score >= 1000

  player_2_position = next_pos(player_2_position, roll + roll + roll)
  player_2_score += player_2_position
  break if player_1_score >= 1000
end

puts $rolls * [player_1_score, player_2_score].min

__END__
Player 1 starting position: 4
Player 2 starting position: 6
