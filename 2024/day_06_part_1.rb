# frozen_string_literal: true

require "matrix"
V = Vector

UP = Vector[-1, 0]
DOWN = Vector[1, 0]
LEFT = Vector[0, -1]
RIGHT = Vector[0, 1]
ROTATE_RIGHT = Matrix[[0, -1], [1, 0]]

map, position = ARGF.each_line.map(&:chomp).each_with_object([Set.new, []]).with_index do |(line, (m, g)), y|
  line.chars.each_with_index do |c, x|
    m << V[x, y] if c == "#"
    g[0] = V[x, y] if c == "^"
  end
end

def draw_grid(grid, positions)
  print((0..grid.max_by { _1[1] }[1]).map do |y|
    (0..grid.max_by { _1[0] }[0]).map do |x|
      if grid.include?(V[x, y])
        "#"
      elsif positions.include?(V[x, y])
        "X"
      else
        "."
      end
    end.join("")
  end.join("\n") + "\n\n")
end

position = position.first
positions = {}
direction = V[0, -1]
x_range = (0..map.max_by { _1[0] }[0])
y_range = (0..map.max_by { _1[1] }[1])

loop do
  new_position = position + direction
  if map.include?(new_position)
    direction = ROTATE_RIGHT * direction
    new_position = position
  end

  break unless x_range.include?(new_position[0]) && y_range.include?(new_position[1])
  break if positions[new_position]&.include?(direction)

  positions[new_position] ||= Set.new
  positions[new_position] << direction
  position = new_position
end

p positions.length
