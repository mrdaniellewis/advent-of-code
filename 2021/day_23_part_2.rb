# frozen_string_literal: true

require "byebug"
require "benchmark"

# State is an array
# 0-6 are the corridor
# [7,8,9,10], [11,12,13,14], [15,16,17,18], [19,20,21,22] are the rooms

# #############
# #01 2 3 4 56#
# ###7#1#5#9###
#   #8#2#6#2#
#   #9#3#7#1#
#   #0#4#8#2#
#   #########

DOUBLE_SCORE = [
  *[1, 2, 7].permutation(2),
  *[2, 3, 11].permutation(2),
  *[3, 4, 15].permutation(2),
  *[4, 5, 19].permutation(2)
].freeze

SCORES = {
  "A" => 1,
  "B" => 10,
  "C" => 100,
  "D" => 1000
}.freeze

ROOMS = {
  "A" => [10, 9, 8, 7],
  "B" => [14, 13, 12, 11],
  "C" => [18, 17, 16, 15],
  "D" => [22, 21, 20, 19]
}.freeze

TRANSITIONS = {
  0 => [
    ["A", [1]],
    ["B", [1, 2]],
    ["C", [1, 2, 3]],
    ["D", [1, 2, 3, 4]]
  ],
  1 => [
    ["A", []],
    ["B", [2]],
    ["C", [2, 3]],
    ["D", [2, 3, 4]]
  ],
  2 => [
    ["A", []],
    ["B", []],
    ["C", [3]],
    ["D", [3, 4]]
  ],
  3 => [
    ["A", [2]],
    ["B", []],
    ["C", []],
    ["D", [4]]
  ],
  4 => [
    ["A", [3, 2]],
    ["B", [3]],
    ["C", []],
    ["D", []]
  ],
  5 => [
    ["A", [4, 3, 2]],
    ["B", [4, 3]],
    ["C", [4]],
    ["D", []]
  ],
  6 => [
    ["A", [5, 4, 3, 2]],
    ["B", [5, 4, 3]],
    ["C", [5, 4]],
    ["D", [5]]
  ],
  7 => [
    ["B", [2]],
    ["C", [2, 3]],
    ["D", [2, 3, 4]],
    [0, [1]],
    [1, []],
    [2, []],
    [3, [2]],
    [4, [2, 3]],
    [5, [2, 3, 4]],
    [6, [2, 3, 4, 5]]
  ],
  11 => [
    ["A", [2]],
    ["C", [3]],
    ["D", [3, 4]],
    [0, [2, 1]],
    [1, [2]],
    [2, []],
    [3, []],
    [4, [3]],
    [5, [3, 4]],
    [6, [3, 4, 5]]
  ],
  15 => [
    ["A", [3, 2]],
    ["B", [3]],
    ["D", [4]],
    [0, [3, 2, 1]],
    [1, [3, 2]],
    [2, [3]],
    [3, []],
    [4, []],
    [5, [4]],
    [6, [4, 5]]
  ],
  19 => [
    ["A", [4, 3, 2]],
    ["B", [4, 3]],
    ["C", [4]],
    [0, [4, 3, 2, 1]],
    [1, [4, 3, 2]],
    [2, [4, 3]],
    [3, [4]],
    [4, []],
    [5, []],
    [6, [5]]
  ]
}

ROOMS.each do |(_, p)|
  p.reverse[1..].each do |i|
    TRANSITIONS[i] = TRANSITIONS[i - 1].map do |(t, moves)|
      [t, [i - 1, *moves]]
    end
  end
end

# #############
# #01 2 3 4 56#
# ###7#9#1#3###
#   #8#0#2#4#
#   #########

initial_state = []

def state_to_string(state)
  state.map { |c| c || "." }.join
end

FINAL_STATE = state_to_string([nil, nil, nil, nil, nil, nil, nil, *("A" * 4), *("B" * 4), *("C" * 4), *("D" * 4)])

DATA.each_line.map(&:chomp).each_with_index do |line, index|
  line[1..-2].split("").each_with_index do |char, i|
    next unless char.match?(/[A-D]/)

    case index
    when 1
      initial_state[[0, 1, nil, 2, nil, 3, nil, 4, nil, 5, 6][i]] = char
    when 2
      initial_state[Hash[[2, 4, 6, 8].zip(ROOMS.values.map { |v| v[3] })][i]] = char
    when 3
      initial_state[Hash[[2, 4, 6, 8].zip(ROOMS.values.map { |v| v[2] })][i]] = char
    when 4
      initial_state[Hash[[2, 4, 6, 8].zip(ROOMS.values.map { |v| v[1] })][i]] = char
    when 5
      initial_state[Hash[[2, 4, 6, 8].zip(ROOMS.values.map { |v| v[0] })][i]] = char
    end
  end
end

def in_home?(state, i)
  ROOMS.any? do |(type, positions)|
    next false unless type == state[i]
    next false unless positions.include?(i)

    positions.none? { |p| state[p] && state[p] != type }
  end
end

def next_states(state, &block)
  state.each_with_index do |pod, i|
    next unless pod
    next if in_home?(state, i)

    TRANSITIONS[i].each do |(target, passing)|
      room = %w[A B C D].include?(target)
      # Skip if the wrong room
      next if room && pod != target
      # Skip if blocked
      next if passing.any? { |p| state[p] }
      # Corridor blocked
      next if target.is_a?(Integer) && state[target]
      # Skip if room contains other types
      next if room && ROOMS[target].any? { |p| state[p] && state[p] != pod }

      new_state = state.dup
      new_state[i] = nil
      if target.is_a?(Integer)
        # Move to corridor
        new_state[target] = pod
        new_passing = [i, *passing, target]
      else
        # Move first open position in room
        room_pos = ROOMS[target].index { |p| !state[p] }
        new_state[ROOMS[target][room_pos]] = pod
        new_passing = [i, *passing, *ROOMS[target][room_pos..].reverse]
      end

      score = new_passing.each_cons(2).map { |pair| (DOUBLE_SCORE.include?(pair) ? 2 : 1) }.sum * SCORES[pod]

      block.call([new_state, score])

      # No need to check any other sequences if we can go immediately to a room
      break if room
    end
  end
end

ROOMS = {
  "A" => [10, 9, 8, 7],
  "B" => [14, 13, 12, 11],
  "C" => [18, 17, 16, 15],
  "D" => [22, 21, 20, 19]
}.freeze

def debug(state)
  puts <<~STATE
    #############
    ##{state[0] || '.'}#{state[1] || '.'} #{state[2] || '.'} #{state[3] || '.'} #{state[4] || '.'} #{state[5] || '.'}#{state[6] || '.'}#
    ####{state[7] || '.'}##{state[11] || '.'}##{state[15] || '.'}##{state[19] || '.'}###
      ##{state[8] || '.'}##{state[12] || '.'}##{state[16] || '.'}##{state[20] || '.'}#
      ##{state[9] || '.'}##{state[13] || '.'}##{state[17] || '.'}##{state[21] || '.'}#
      ##{state[10] || '.'}##{state[14] || '.'}##{state[18] || '.'}##{state[22] || '.'}#
      #########
  STATE
  puts
end

debug(initial_state)

$scores = []
$best_score = Float::INFINITY
all_states = Hash.new { Float::INFINITY }
incomplete_states = [[initial_state, 0]]

pp(Benchmark.measure do
  loop do
    new_states = []

    incomplete_states.each do |(state, score)|
      next_states(state) do |(next_state, add_score)|
        new_score = score + add_score
        string_state = state_to_string(next_state)

        next if all_states[string_state] <= new_score
        next $scores << new_score if string_state == FINAL_STATE

        all_states[string_state] = new_score
        new_states << [next_state, new_score]
      end
    end

    break if new_states.empty?

    incomplete_states = new_states
  end
end)

pp $scores.min

__END__
#############
#...........#
###A#C#B#D###
  #D#C#B#A#
  #D#B#A#C#
  #B#A#D#C#
  #########
