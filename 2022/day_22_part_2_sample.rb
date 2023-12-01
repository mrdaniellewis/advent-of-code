# frozen_string_literal: true

require "matrix"

data = $stdin.read

instructions = []
grid = {}

X = 0
Y = 1

data.each_line(chomp: true) do |line|
  if line.match?(/^(\d|R|L)/)
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
FLIP = Matrix[[-1, 0], [0, -1]]

ymin, ymax = grid.keys.map { _1[Y] }.minmax
xmin, xmax = grid.keys.map { _1[X] }.minmax
journey = { cursor => direction }

yparts = 5.times.map { _1 * xmax / 4 }
xparts = 4.times.map { _1 * ymax / 3 }

instructions.each do |i|
  case i
  when "R"
    direction = RIGHT * direction
  when "L"
    direction = LEFT * direction
  else
    count = i
    pos = cursor
    dir = direction
    loop do
      break if count == 0

      pos += dir
      if pos[Y] > ymax
        case pos[X]
        when yparts[0]..yparts[1]
          dir = FLIP * dir
          pos = Vector[yparts[2] + 1 + (yparts[1] - pos[X]), ymax]
        when yparts[1] + 1..yparts[2]
          dir = LEFT * dir
          pos = Vector[yparts[1] + 1, yparts[2] - (pos[X] - (xparts[2] + 1))]
        when yparts[2] + 1..yparts[3]
          dir = FLIP * dir
          pos = Vector[yparts[1] - (pos[X] - (yparts[2] + 1)), xparts[2]]
        when yparts[3] + 1..yparts[4]
          dir = LEFT * dir
          pos = Vector[0, xparts[1] + 1 + (xmax - pos[X])]
        end
      elsif pos[Y] < ymin
        case pos[X]
        when yparts[0]..yparts[1]
          dir = FLIP * dir
          pos = Vector[yparts[3] - pos[X], 0]
        when yparts[1] + 1..yparts[2]
          dir = RIGHT * dir
          pos = Vector[yparts[2] + 1, pos[X] - (yparts[1] + 1)]
        when yparts[2] + 1..yparts[3]
          dir = FLIP * dir
          pos = Vector[yparts[1] - (pos[X] - (yparts[2] + 1)), xparts[1] + 1]
        when yparts[3] + 1..yparts[4]
          dir = LEFT * dir
          pos = Vector[yparts[3], xparts[2] - (pos[X] - (yparts[3] + 1))]
        else
          raise "fail"
        end
      elsif pos[X] > xmax
        case pos[Y]
        when xparts[0]..xparts[1]
          dir = FLIP * dir
          pos = Vector[xmax, xparts[2] + 1 + (xparts[1] - pos[Y])]
        when xparts[1] + 1..xparts[2]
          dir = RIGHT * dir
          pos = Vector[yparts[3] + 1 + xparts[2] - pos[Y], xparts[2] + 1]
        when xparts[2] + 1..xparts[3]
          dir = FLIP * dir
          pos = Vector[yparts[3], 0 + ymax - pos[Y]]
        else
          raise "fail"
        end
      elsif pos[X] < xmin
        case pos[Y]
        when xparts[0]..xparts[1]
          dir = LEFT * dir
          pos = Vector[yparts[1] + 1 + pos[Y], xparts[1] + 1]
        when xparts[1] + 1..xparts[2]
          dir = RIGHT * dir
          pos = Vector[yparts[3] + 1 + (pos[Y] - (xparts[1] + 1)), ymax]
        when xparts[2] + 1..xparts[3]
          dir = RIGHT * dir
          pos = Vector[yparts[1] + 1 + ymax - pos[Y], xparts[2]]
        else
          raise "fail"
        end
      end

      case grid[pos]
      when "#"
        break
      when "."
        cursor = pos
        direction = dir
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
