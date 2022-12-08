# frozen_string_literal: true

data = $stdin.read

grid = data.each_line(chomp: true).map { |row| row.chars.map { |cell| [cell.to_i, Array.new(4)] } }

TOP = 0
RIGHT = 1
BOTTOM = 2
LEFT = 3

# [TOP, RIGHT, BOTTOM, LEFT]

(0...grid.length).each do |y|
  max = -1
  (0...grid[0].length).each do |x|
    height = grid[y][x][0]
    visible = height > max
    max = height if visible
    grid[y][x][1][LEFT] = visible
  end

  max = -1
  (0...grid[0].length).to_a.reverse.each do |x|
    height = grid[y][x][0]
    visible = height > max
    max = height if visible
    grid[y][x][1][RIGHT] = visible
  end
end

(0...grid[0].length).each do |x|
  max = -1
  (0...grid.length).each do |y|
    height = grid[y][x][0]
    visible = height > max
    max = height if visible
    grid[y][x][1][TOP] = visible
  end

  max = -1
  (0...grid.length).to_a.reverse.each do |y|
    height = grid[y][x][0]
    visible = height > max
    max = height if visible
    grid[y][x][1][BOTTOM] = visible
  end
end

# puts grid.map { |r| r.map { |c| "#{c[0]}#{c[1].any? ? 'T' : 'F' }" }.join }.join("\n")

pp grid.flat_map(&:itself).select { _1[1].any? }.count
