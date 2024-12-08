# frozen_string_literal: true

require "matrix"
V = Vector

MAP = ARGF.each_line.map(&:chomp).map.with_index do |line, y|
  line.chars.map.with_index do |c, x|
    [V[x, y], c]
  end.compact
end.flatten(1).to_h

Y_RANGE = 0..MAP.keys.max_by { _1[1] }[1]
X_RANGE = 0..MAP.keys.max_by { _1[0] }[0]
MAP.delete_if { |_, v| v == "." }

def draw_grid(antinodes = Set.new)
  print(Y_RANGE.map do |y|
    X_RANGE.map do |x|
      next "#" if antinodes.include?(V[x, y])

      MAP[V[x, y]] || "."
    end.join("")
  end.join("\n") + "\n\n")
end

GROUPED = MAP.group_by { |_k, v| v }.transform_values { _1.map(&:first) }

MAP
  .map do |position, frequency|
    (GROUPED[frequency] - [position]).map do |target|
      distance = target - position
      [
        target + distance,
        position - distance
      ]
    end
  end
  .flatten
  .select do |position|
    X_RANGE.include?(position[0]) && Y_RANGE.include?(position[1])
  end
  .uniq
  .tap { draw_grid(_1) }
  .then { p _1.count }
