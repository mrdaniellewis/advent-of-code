# frozen_string_literal: true

data = $stdin.read

grid = data.each_line(chomp: true).map { |row| row.chars.map { |cell| [cell.to_i, Array.new(4, 0)] } }

(1...grid.length - 1).each do |y|
  (1...grid[0].length - 1).each do |x|
    height = grid[y][x][0]

    view = 0
    (0...y).reverse_each do |y1|
      view += 1
      break if grid[y1][x][0] >= height
    end
    grid[y][x][1][0] = view

    view = 0
    (y + 1...grid.length).each do |y1|
      view += 1
      break if grid[y1][x][0] >= height
    end
    grid[y][x][1][1] = view

    view = 0
    (0...x).reverse_each do |x1|
      view += 1
      break if grid[y][x1][0] >= height
    end
    grid[y][x][1][2] = view
    next if view == 0

    view = 0
    (x + 1...grid[0].length).each do |x1|
      view += 1
      break if grid[y][x1][0] >= height
    end
    grid[y][x][1][3] = view
  end
end

# puts grid.map { |r| r.map { |c| "#{c[0]}#{c[1]}" }.join }.join("\n")

pp grid.flatten(1).map { _1[1].inject(:*) }.max
