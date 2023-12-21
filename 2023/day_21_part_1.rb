# frozen_string_literal: true

require "matrix"
V = Vector

start = nil
GRID = ARGF.each_line.map(&:chomp).each_with_object(Set.new).with_index do |(line, h), y|
  line.chars.each_with_index do |char, x|
    h << V[x, y] if ".S".include?(char)
    start = V[x, y] if char == "S"
  end
end

XRANGE = Range.new(*GRID.map { _1[0] }.minmax)
YRANGE = Range.new(*GRID.map { _1[1] }.minmax)

pp GRID

def debug(positions = Set.new)
  YRANGE.map do |y|
    XRANGE.map do |x|
      pos = V[x, y]
      if positions.include?(pos) then "O"
      elsif GRID.include?(pos) then "."
      else
        "#"
      end
    end.join("")
  end.join("\n") + "\n\n"
end

puts debug(Set[start])

DIRECTIONS = [V[0, 1], V[0, -1], V[1, 0], V[-1, 0]]

# Any square can be revisited if it has an even step count

# Visit each surrounding square
# Mark the steps required to get there
# If not visited previously add to the loop
