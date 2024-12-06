# frozen_string_literal: true

require "matrix"
V = Vector

UP = V[-1, 0]
DOWN = V[1, 0]
LEFT = V[0, -1]
RIGHT = V[0, 1]
ROTATE_RIGHT = Matrix[[0, -1], [1, 0]]

MAP = Set.new

ARGF.each_line.map(&:chomp).each_with_index do |line, y|
  line.chars.each_with_index do |c, x|
    MAP << V[x, y] if c == "#"
    START = V[x, y] if c == "^"
  end
end

X_RANGE = (0..MAP.max_by { _1[0] }[0])
Y_RANGE = (0..MAP.max_by { _1[1] }[1])

def draw_grid(positions, obstical = nil)
  print(Y_RANGE.map do |y|
    X_RANGE.map do |x|
      if MAP.include?(V[x, y])
        "#"
      elsif V[x, y] == obstical
        "O"
      elsif positions.include?(V[x, y])
        "X"
      else
        "."
      end
    end.join("")
  end.join("\n") + "\n\n")
end

def patrol(obstacle = nil)
  positions = {}
  direction = V[0, -1]
  position = START

  loop do
    new_position = position + direction
    if MAP.include?(new_position) || new_position == obstacle
      direction = ROTATE_RIGHT * direction
      new_position = position
    end

    break unless X_RANGE.include?(new_position[0]) && Y_RANGE.include?(new_position[1])

    # draw_grid(positions, obstacle) if positions[new_position]&.include?(direction)
    throw :loop, obstacle if positions[new_position]&.include?(direction)

    positions[new_position] ||= Set.new
    positions[new_position] << direction
    position = new_position
  end

  positions
end

(patrol.keys - [START]).count do |position|
  catch(:loop) do
    patrol(position)
    false
  end
end.then { p _1 }
