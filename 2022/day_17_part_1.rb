# frozen_string_literal: true

require "matrix"

data = $stdin.read

rock_input = <<~ROCKS
  ####

  .#.
  ###
  .#.

  ..#
  ..#
  ###

  #
  #
  #
  #

  ##
  ##
ROCKS

JETS = data.strip.chars

ROCKS = rock_input.split("\n\n").map do |rock|
  rows = rock.split("\n")
  rows.flat_map.with_index do |row, y|
    row.chars.flat_map.with_index do |c, x|
      next if c == "."

      Vector[x, y - rows.length + 1]
    end
  end.compact
end

def draw(grid, rock = nil)
  puts
  ymin = (grid.keys.map { _1[1] } + (rock&.map { _1[1] } || [0])).min
  (ymin..0).each do |y|
    print "|"
    7.times do |x|
      print grid[Vector[x, y]] || (rock&.any?(Vector[x, y]) && "%") || "."
    end
    print "|\n"
  end
  print "+-------+\n\n"
end

rock_count = 0
jet_count = 0

grid = {}

loop do
  rock = ROCKS[rock_count % ROCKS.length]
  rock_count += 1
  top = grid.keys.map { _1[1] }.min || 1

  rock = rock.map do |pos|
    pos + Vector[2, top - 4]
  end

  loop do
    jet = JETS[jet_count % JETS.length]
    jet_count += 1

    # Gust
    new_rock = rock.map do |pos|
      pos + (jet == ">" ? Vector[1, 0] : Vector[-1, 0])
    end

    rock = new_rock if new_rock.none? { _1[0] == -1 || _1[0] == 7 || grid[_1] }

    # Move down
    new_rock = rock.map do |pos|
      pos + Vector[0, 1]
    end

    break if new_rock.any? { grid.key?(_1) || _1[1] == 1 }

    rock = new_rock
  end

  rock.each { grid[_1] = "%" }

  break if rock_count == 2022
end

pp grid.keys.map { _1[1] }.min.abs + 1
