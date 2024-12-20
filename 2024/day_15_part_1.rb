# frozen_string_literal: true

require "matrix"
V = Vector

grid, moves, robot = ARGF.read.each_line.map(&:chomp).each_with_object([{}, []]).with_index do |(line, memo), y|
  g, m = memo
  if line.include?("#")
    line.chars.map.with_index do |c, x|
      memo << V[x, y] if c == "@"
      g[V[x, y]] = c if c != "."
    end
  else
    m.push(*line.chars)
  end
end

Y_RANGE = 0..grid.keys.max_by { _1[1] }[1]
X_RANGE = 0..grid.keys.max_by { _1[0] }[0]
MOVES = {
  "<" => V[-1, 0],
  "^" => V[0, -1],
  ">" => V[1, 0],
  "v" => V[0, 1]
}

def draw_grid(grid)
  print(Y_RANGE.map do |y|
    X_RANGE.map do |x|
      grid[V[x, y]] || "."
    end.join("")
  end.join("\n") + "\n\n")
end

def push(grid, from, dir)
  move_to = from + dir
  target = grid[move_to]
  target = push(grid, move_to, dir) if target == "O"
  if target.nil?
    grid[move_to] = grid[from]
    grid.delete(from)
  end
  target
end

moves.each do |move|
  robot += MOVES[move] unless push(grid, robot, MOVES[move])
end

grid
  .filter_map do |v, c|
    next unless c == "O"

    v[0] + 100 * v[1]
  end
  .sum
  .then { p _1 }
