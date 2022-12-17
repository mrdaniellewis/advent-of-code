# frozen_string_literal: true

require "matrix"
require "set"

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

# Turn the rock into a list of vectors
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
  ymin, ymax = (grid.map { _1[1] } + (rock&.map { _1[1] } || [])).minmax
  (ymin || 0..ymax || 0).each do |y|
    print "|"
    7.times do |x|
      print(grid.include?(Vector[x, y]) || rock&.any?(Vector[x, y]) ? "%" : ".")
    end
    print "|\n"
  end
  print "+-------+\n\n"
end

ROW_COVERED = Set.new(0..6)

# Generates a cache position
# Take the top section of the grid where no blocks can get past
# Normalise coordinates so 0 is the top
def truncate_grid(grid)
  return grid if grid.empty?

  ymin, ymax = grid.map { _1[1] }.minmax
  cover = Set.new
  new_grid = Set.new
  consecutive = Array.new(7, 0)

  (ymin..ymax).each do |y|
    xused = Set.new
    grid.filter { _1[1] == y }.each do |cell|
      new_grid << Vector[cell[0], cell[1] + ymin.abs]
      cover << cell[0]
      xused << cell[0]
    end

    # A bit crude but avoid situations where the 4 tall block can be blown back through a gap
    # Could be improved to create shorted grid sections, but works OK
    7.times do |i|
      if xused.include?(i)
        consecutive[i] = 0
      else
        consecutive[i] += 1
      end
    end

    break if ROW_COVERED == cover && consecutive.all? { _1 < 4 }
  end

  new_grid
end

rock_count = 0
jet_count = 0

# Start with just a floor
grid = Set.new((0..6).map { Vector[_1, 0] })

# Cache of previous positions
position_caches = Hash.new { |h, k| h[k] = [] }

total_height = 0

TARGET = 1_000_000_000_000
# TARGET = 2022

loop do
  break if rock_count == TARGET

  # Cache by the rock, the jet and the truncated position
  # Each time we see the same position add a line to this cache
  # We can use to to exponentially increase the jumps
  position_cache = position_caches[[rock_count % ROCKS.length, jet_count % JETS.length, grid.dup]]
  position_cache << {
    rock_count:,
    jet_count:,
    total_height:,
    grid: grid.dup
  }

  if position_cache.length > 1
    # Find the best cached position that isn't the current position
    # And doesn't jump us beyond the target
    cached = position_cache.filter do |c|
      new_count = rock_count + c[:rock_count] - position_cache[0][:rock_count]
      new_count <= TARGET && new_count > rock_count
    end.last

    if cached
      # Shortcut to the cached position
      rock_count += cached[:rock_count] - position_cache[0][:rock_count]
      jet_count += cached[:jet_count] - position_cache[0][:jet_count]
      total_height += cached[:total_height] - position_cache[0][:total_height]
      grid = cached[:grid]

      next
    end
  end

  rock = ROCKS[rock_count % ROCKS.length]

  # Move the rock 3 units above the top
  rock = rock.map do |pos|
    pos + Vector[2, -4]
  end

  loop do
    jet = JETS[jet_count % JETS.length]
    jet_count += 1

    # Gust move the rock
    new_rock = rock.map do |pos|
      pos + (jet == ">" ? Vector[1, 0] : Vector[-1, 0])
    end

    # Check for collisions before committing
    rock = new_rock if new_rock.none? { _1[0] == -1 || _1[0] == 7 || grid.include?(_1) }

    # Move rock down
    new_rock = rock.map do |pos|
      pos + Vector[0, 1]
    end

    # Check for collisions before committing
    break if new_rock.any? { grid.include?(_1) }

    rock = new_rock
  end

  # Draw the finalised rock on our grid
  rock.each { grid << _1 }

  # The grids bottom is at 0, so add the new top
  total_height += grid.map { _1[1] }.min.abs

  # Truncate the grid to give us a cache position
  grid = truncate_grid(grid)

  rock_count += 1
end

pp total_height
