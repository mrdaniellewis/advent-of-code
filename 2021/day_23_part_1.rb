# frozen_string_literal: true

require "byebug"
require "benchmark"

# State is an array
# 0-6 are the corridor
# [7,8], [9,10], [11, 12], [13, 14] are the rooms

# #############
# #01 2 3 4 56#
# ###7#9#1#3###
#   #8#0#2#4#
#   #########

DOUBLE_SCORE = [
  *[1, 2, 7].permutation(2),
  *[2, 3, 9].permutation(2),
  *[3, 4, 11].permutation(2),
  *[4, 5, 13].permutation(2)
].freeze

SCORES = {
  "A" => 1,
  "B" => 10,
  "C" => 100,
  "D" => 1000
}.freeze

ROOMS = {
  "A" => [8, 7],
  "B" => [10, 9],
  "C" => [12, 11],
  "D" => [14, 13]
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
  8 => [
    ["B", [7, 2]],
    ["C", [7, 2, 3]],
    ["D", [7, 2, 3, 4]],
    [0, [7, 1]],
    [1, [7]],
    [2, [7]],
    [3, [7, 2]],
    [4, [7, 2, 3]],
    [5, [7, 2, 3, 4]],
    [6, [7, 2, 3, 4, 5]]
  ],
  9 => [
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
  10 => [
    ["A", [9, 2]],
    ["C", [9, 3]],
    ["D", [9, 3, 4]],
    [0, [9, 2, 1]],
    [1, [9, 2]],
    [2, [9]],
    [3, [9]],
    [4, [9, 3]],
    [5, [9, 3, 4]],
    [6, [9, 3, 4, 5]],
  ],
  11 => [
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
  12 => [
    ["A", [11, 3, 2]],
    ["B", [11, 3]],
    ["D", [11, 4]],
    [0, [11, 3, 2, 1]],
    [1, [11, 3, 2]],
    [2, [11, 3]],
    [3, [11]],
    [4, [11]],
    [5, [11, 4]],
    [6, [11, 4, 5]]
  ],
  13 => [
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
  ],
  14 => [
    ["A", [13, 4, 3, 2]],
    ["B", [13, 4, 3]],
    ["C", [13, 4]],
    [0, [13, 4, 3, 2, 1]],
    [1, [13, 4, 3, 2]],
    [2, [13, 4, 3]],
    [3, [13, 4]],
    [4, [13]],
    [5, [13]],
    [6, [13, 5]]
  ]
}.freeze

# #############
# #01 2 3 4 56#
# ###7#9#1#3###
#   #8#0#2#4#
#   #########

initial_state = []

def state_to_string(state)
  state.map { |c| c || "." }.join
end

FINAL_STATE = state_to_string([nil, nil, nil, nil, nil, nil, nil, "A", "A", "B", "B", "C", "C", "D", "D"])

DATA.each_line.map(&:chomp).each_with_index do |line, index|
  line[1..-2].split("").each_with_index do |char, i|
    next unless char.match?(/[A-D]/)

    case index
    when 1
      initial_state[[0, 1, nil, 2, nil, 3, nil, 4, nil, 5, 6][i]] = char
    when 2
      initial_state[{ 2 => 7, 4 => 9, 6 => 11, 8 => 13 }[i]] = char
    when 3
      initial_state[{ 2 => 8, 4 => 10, 6 => 12, 8 => 14 }[i]] = char
    end
  end
end

def in_home?(state, i)
  ROOMS.any? do |(type, (r1, r2))|
    next true if i == r1 && type == state[i]
    next true if i == r2 && type == state[r1] && type == state[i]

    false
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
        room_pos = ROOMS[target].find { |p| !state[p] }
        new_state[room_pos] = pod
        new_passing = [i, *passing, ROOMS[target][1]]
        new_passing << ROOMS[target][0] if ROOMS[target][0] == room_pos
      end

      score = new_passing.each_cons(2).map { |pair| (DOUBLE_SCORE.include?(pair) ? 2 : 1) }.sum * SCORES[pod]

      block.call([new_state, score])

      # No need to check any other sequences if we can go immediately to a room
      break if room
    end
  end
end

def debug(state)
  puts <<~STATE
    #############
    ##{state[0] || '.'}#{state[1] || '.'} #{state[2] || '.'} #{state[3] || '.'} #{state[4] || '.'} #{state[5] || '.'}#{state[6] || '.'}#
    ####{state[7] || '.'}##{state[9] || '.'}##{state[11] || '.'}##{state[13] || '.'}###
      ##{state[8] || '.'}##{state[10] || '.'}##{state[12] || '.'}##{state[14] || '.'}#
      #########
  STATE
  puts
end

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
  #B#A#D#C#
  #########
