# frozen_string_literal: true

require "matrix"

data = $stdin.read

instructions = []
grid = {}

X = 0
Y = 1

data.each_line(chomp: true) do |line|
  if line.match?(/^\d/)
    instructions = line.scan(/\d+|L|R/).map { _1.match?(/\d/) ? _1.to_i : _1 }
    next
  end

  y = (grid.keys.map { _1[Y] }.max || -1) + 1
  line.chars.each_with_index do |char, x|
    grid[Vector[x, y]] = char unless char == " "
  end
end

DIRECTION_GLIFS = { Vector[1, 0] => ">", Vector[-1, 0] => "<", Vector[0, 1] => "v", Vector[0, -1] => "^" }

def draw(grid, journey)
  ymin, ymax = grid.keys.map { _1[Y] }.minmax
  xmin, xmax = grid.keys.map { _1[X] }.minmax

  puts
  (ymin..ymax).each do |y|
    (xmin..xmax).each do |x|
      if journey[Vector[x, y]]
        print DIRECTION_GLIFS[journey[Vector[x, y]]]
      else
        print(grid[Vector[x, y]] || " ")
      end
    end
    print "\n"
  end
end

cursor = Vector[grid.find { _1[Y] == 0 && _2 == "." }[0][X], 0]
direction = Vector[1, 0]

RIGHT = Matrix[[0, -1], [1, 0]]
LEFT = Matrix[[0, 1], [-1, 0]]

ymin, ymax = grid.keys.map { _1[Y] }.minmax
xmin, xmax = grid.keys.map { _1[X] }.minmax
journey = {}

draw grid, journey

instructions.each do |i|
  case i
  when "R"
    direction = RIGHT * direction
  when "L"
    direction = LEFT * direction
  else
    count = i
    pos = cursor
    loop do
      break if count == 0

      pos += direction
      if pos[Y] > ymax
        pos = Vector[pos[X], 0]
      elsif pos[Y] < ymin
        pos = Vector[pos[X], ymax]
      elsif pos[X] > xmax
        pos = Vector[0, pos[Y]]
      elsif pos[X] < xmin
        pos = Vector[xmax, pos[Y]]
      end

      case grid[pos]
      when "#"
        break
      when "."
        cursor = pos
        count -= 1
        journey[cursor] = direction
      end
    end
  end

  journey[cursor] = direction
end

draw grid, journey

DIRECTION_SCORES = { Vector[1, 0] => 0, Vector[-1, 0] => 2, Vector[0, 1] => 1, Vector[0, -1] => 3 }

pp 1000 * (cursor[Y] + 1) + 4 * (cursor[X] + 1) + DIRECTION_SCORES[direction]
