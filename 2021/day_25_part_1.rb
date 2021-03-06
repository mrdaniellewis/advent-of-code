# frozen_string_literal: true

require "byebug"

grid = []

DATA.each_line.map(&:chomp).each do |line|
  grid << line.split("").map do |char|
    "v>".include?(char) ? char : nil
  end
end

def debug(grid)
  puts(grid.map do |line|
    line.map { |char| char || "." }.join
  end.join("\n"))
  puts
end

debug(grid)
$height = grid.length
$width = grid[0].length

def next_x(x)
  return 0 if x == $width - 1

  x + 1
end

def prev_x(x)
  return $width - 1 if x == 0

  x - 1
end

def next_y(y)
  return 0 if y == $height - 1

  y + 1
end

def prev_y(y)
  return $height - 1 if y == 0

  y - 1
end

count = 0

loop do
  count += 1
  moved = false

  grid = grid.map do |line|
    line.map.with_index do |char, x|
      if char == ">" && line[next_x(x)].nil?
        moved = true
        nil
      elsif char.nil? && line[prev_x(x)] == ">"
        ">"
      else
        char
      end
    end
  end

  grid = grid.map.with_index do |line, y|
    line.map.with_index do |char, x|
      if char == "v" && grid[next_y(y)][x].nil?
        moved = true
        nil
      elsif char.nil? && grid[prev_y(y)][x] == "v"
        "v"
      else
        char
      end
    end
  end

  debug(grid)

  break unless moved
end

pp count

__END__
.v>....v.vv....v..>v..v>.vv>>>>>v>.v..>>v.vvv.>>..>.>v..v.>>....v...>>v...>..>.>>v..v...v.v.v.>>>.v>.vv>v>v..v>>>.>...>v.>.>>.v..v.vv.vv>..
>.>.>..>..v>...v.>.>..v..v.......>>>v...>>>v.>v..>...>v.v>.>..>.>>.....>>vv.....>.>v>.v.........>v..>v..>v..v>.....v...>>..v.v.>.v...>v.>..
.>.v..>...v..>>.v..v.v>vv>.v...v.>>.>v..v...v.v..v.>.v.>v.>>v>.v>.>v.>.>.v..>>v>.>>v...>...>...vv.v.>v.>.v.v..vv>.v.v..v..v.v>vv>.v.>..>>>.
..v...>.vv>.v..>>>.>....v.>.>...>v.>vv.v>>>..v..>......>.>..v.>.>v...>.v....>>.v..v.v.v.v.v.>>v>v.>>.v>...>v.>v.....v.v....v>...>v.v.v.>v>v
>v>vv.>>..vv.vv....>.>..>.vv..>>v.>>..>..v>.v..v.>..vvvvvv>>.v.>v.v..v.>.v>.v.>>...vv.>v>vv.>>>>>v....>>>>.v.v.>v.>.....>.>.v>...vvv>v>.>..
...vv.v>.>>>>>>..v>..>>v.vvv...v.>..v>v..>v>.>v..>.v.v..>..v.>.>.v.>.>.vvv.v>.>v...>.>..>>.v>...>.v..>v>.>.>.vvv>..vvv.v.>vv.v.>.v..>..v.v.
>vv>...v.>..>..>.>>.v>v.>vv..>v>..>..>>..>.....>.v.>vvv>..>......>..v.>>....v>.>..>.vv.>>>.>v>.>>>>..v.>vv..vv>.v.>>v..v>v.>v..>....v..v..v
>.>....v....v..v...v>>.v>.>>>..>..v.>v>...>>.v>vvv..vv.v.v.>.>.v>>..v...v.v>.>..>..>.vv>>..>v....v>v>.v..v.>.v.v>v..>.>v>v.>v>>>.>v..v>>vv.
.>..v.vvv>...>>.>>>....v>.v>>>..v.>.>>..>>>v>>..v..>v>.>>....v>v>>.>.>v....>v.v>>..>....v.>v.v>v.>>vv>>>.vv.>>v..v.v>>.vvvv>..>v>v.>vv..>>.
v>.v.>vv...vv.v>.v..>>.>v.>v>..vv.v.v..v.v>>......v>>..v.....vvv...vv.v..vvv.>.vv>v>..>v>.....>...vv.v>.vv.>>.>.v.vvv>..v>.v.vvvv.v>....v.>
v.v...v..>..>..>.v..vv>>..v..>>>v..vv..vv>..v.>>...>>..>v..v.>.>>.v>......>v....v.vvv...v..v>..v>>.v>..vvv>v.v>..v>v.>>>....vv..v.>v>>....v
v>..>..>..vv.v>>v.v>v..v...>...v>.v.v>v..v..>.>.>vv.>>..vvv.vv>...vv..>.>>..vv.v>v>v...v>..>v.....>...>..........>...v..v..v.>>.>.v..>.vv>.
..v....v...v>..>..vvv.v>.>.v...>..v.v......>..>...v.>>>.vv..>>vvv.vv.>v.v.>.>..vv>.....v>v>.>>.>.>.vv>.v.>v>v.v>..>v.>v....vv.vv...vv..>..>
>v.>>vv>.vv...>.>v.v......>..>.v>...v>>v..>>..>....>...v...>v.vv..>vvv.....v>.v.v>..>>.vv..>.>..vv.v>vv>>v.>...>>>.>v>......v.>.>..>.>..vv.
.v...v.>.vvvvv......v.>.v.>vvv.>>>>>.vvv>..v...>.v>>...v......vv>..>>>v...>>v...>v...........>.v.>...>v.v.v.v..>>v.vvv>....v>.>>.v.>.>...>.
..>..>.>>.v.vv..>>v..v...>v.>.v>..>.>v.v.....>.v.......v..>>...>.....v...vv>>v..>>....vv>>..vv..>>>.>>..>.>.>>..v>.vvv>>....>..v>vv.v>>..v.
....v.....v.>vv.>>>.>..v..>..v>...v...v..vv>>v.v..>>v...v.>.v.v..v.vv..>.>>v..>.>.vv>.>......>..........>v.v.>v.vv>.v.vvvv>..>.>>....>>>v.>
.v.>......v>vv.>v..v>vv.vvv>.>>.vv.v>.>v.vvvvvv.vv.v.>.....>..v....>..v.>...>>....>.>.>.......>v.>v..v>v>>...>.>.....v..v..>vvvv...>...v>>.
v.....v.v.vv.>>>v>v>v>.v..>..v.>v...>>.>...>....v..>>v....v>>>.vv>>>.v.>.....>.>.>...v>>.>.v..v>>.>>.v>>..v..v>v.v>v>>..v..v.v>>>.>v....>.>
..>.vvvv>>v.>v....>vv..>v>....vv.......v.>v>v.v.vv.>.>..>...>>v...v...v>>v.v.v.>.>>..v>..vv....>..>vvvv.v..v.v>>.v>v.>.v...v.>v..>.v.....vv
.v.v..v>>..v....v.v.>.v.v....>>>.v.....v.>...v>.v..v.....>>...v.v>.v.....vv>>....v...v>.........>vv..vv>>..v.>>vvv.....>..>v.....>..>..v>..
..v....vv>v..v..vvv.>.>.>v..v.vv>.v.v>...v>>.v.v.v>...vv..v>v.....v..v.v.>....>>...>v.>v.>.>>vvvv...........>vv..>..>..>>..v>...v>>.v.v.>.>
..v>..v>.>.....>.>....vv...vv...>.....>>.>>.>..>>.>>.>.>vv...>>>v.>>..v>>....v.v.>>..v.>v.....>>.vv.v....>>>...>.>....v..>.vv.>v>.v.....vvv
v>>.>.vv.....>>vvvv..vv..v..v>.>....vv.>v.vv>..>>vv>...v.>>...>..v.>v.>.vv>>vvvv.>..>.v>.v.>....>>...>.>>v..>v.>>vv.>.>>>.>..>..>v..v.vvvv.
>>vv.v>>>.>>..v>>>..vv.v>>.>.....v>vvv.v...v.v>..v.>.>>...v...>.>v>vv..>>>.>v>v....>..v>>..>v...>..>>>...vv.>>>...>...>....>v.>>..>>.vv.v..
..>vv..v..v.v..>...>>v.v>>v..>>>v>..v>....>>>..vv>.>>.v..vv..v>.v>.>>>.>>.v>v..v>v>>.v..>...v>>>...vvv>.v...>......>v>.vvv.vv..>>...vv>vv..
.v..>v...>....v......>>..v>v..v.v..>>....>vv>v..>>>....v>....v>.v>>..v>.v.v....>.>..v...>.>.>.>v..>....vv>v>>v...>.>.v...vv....vv>>>....vv.
..v..>.>...v>..v.v>>>.>v>v.vv..>>>>>>..>vv>v.v.>>....v>vvv..>.v>v>.>>.v..>vv>>......vv>vv>>v.>.v...>.v..>.>.>.>v.v.v.v>..>....>.v.v....>>vv
vv..>v..>.vvv>>.>.v.vv>..>v.v.v..>.>.vv>>..v..>v>v.>..v>>v.>.vv.>>v..vv.>.>...v..>v>>vvvv>v.v.v..v.>v..>..v>>....>..>v>....v.>..>....>..v>.
>.v.>>>>v>.v>v..>v.v>.v.>>......>.v.>>>v..>v...v...v.vv..v.>>..v...v.>.v>v>v.vv>>>..>v>.........vv..vv>......>....>>>..v>v.>v>>..v.>>..v>>.
v.v>..>v.v..>>...>.vv>v..>>.v...>..>v>.v.v.v.v.>.v.v...vv...>>.>.>.>.vv...>>.>vv...v>.>>...v...>.>>..v.v..>v..v.>v.vv.v....>>v......v.>vv..
...>.>..v......v>>v>.v....vv.......>..vv...v.vvvvvv>...v.>..v..v.v..>.....>v.>..>.>v>..v...>v.>>>v.v.vv...>>v>v.vv..>v>.....vv.>.>.>.>.>.vv
....v.v.v>..vv....>...>>vvv..v>vv>.>.vvvvv>v>v.v>...>..>..v.v.>v..>...v..vv>>v>v>.vv.>...v.>>vv...vv>>.>...v.v.v.>>.........>vv..>>..>>v>.v
..>>.v.>.v.>>.>..v>>>..>..v...v.v..>.vv.v>.>>>v.>.v.......v...v..v...vv.>......v....>.>...vv..>>vv.v.v...>>>..>>>.>..v>>.v...v.>vvvvvv...v.
.>vv>.v>.vv..>.>..>>vvv.vv..>>v.v>>..>v....>vv>>>vv..>v.v>..>.....v>>v.......v.>...>>.>....>.>v..v......>.>v..vv....>.vv>..v>v>>>.>.>.vv...
...>>vvv>>>.......v.v>v>>..>>vv.>..vv..vv..>>v....>vv.>...v>>v..>vv....>....v>..vvv....>.>.>......>>..>.>v>v.>..>v>>>......>>.vvvv.v....>v.
>...v>....>.>v..>....>>..vvv.......>>>>...>v.>>>...>.......v..>...vvvv>vv...v.v.v>>...>>>>.>.>>>.>>>......vv>>..v.>v.vvvvv......v.>v...vv..
v....>v.>>.>..v>.v..v.vv...v.>..>>>.......>>.v....v>.vv.>v..v.>....vvv>.>.......>...vvv>.v>v>>..>..v.>.>...>>.....>.vvv.>.>v>.v.v..v.vvv.v.
...>>v>.vv.v.vvv.>>..>..v...v>v..>....v.v.>v..>.....>>.v..>>>>v>>.......>v>..v>>.v.>.v>v...v>..vvvv...>>v.>>...v.v>.v>v.v>>.>>>>v>>.v>>>.v>
.>>......>v>.>...>..>.vvvv>>...v.v>>.>..>.>...v.....>>...v..v.>.>vv>..>v>..vv>..>>>v..>..v...>..>vv....vvvv.v>..>.>>v>..v..>>......v.>.v.v.
.>>.v.vvv.v..>>v..v..v......vv>.....vv>..vvv>.v..vvv>>.vv.v>.>.vv.v.v..>..>..v>..v>..v>>......>>.>.v.>>>v>vv..>>.>>...vv>v.>.v..>>.v....>.v
v>v...v...>..v...>v>>.v...vvv.v>.>vvv>>>>.....v.v>..v>vv.>v....>.vv...v>v>...>v.v.>...vv>..v>...v>.v.>>vv>..>>...>..>.....v...v.v.v>>vv.>>.
>v....>.....v...>..vv>.v...v>v>..>..v..>..v..>>>...v>vv>v..>..v.v>v>...>>...v..v>>v..v..>.>...v>>vv.v..>.v.v>.v>.v.>.>...v.>..vv>...vvv....
v>.v>.>v>>>>>v>v>>v..>>vv>.>.>>.>.>.v.v.>v.>v>>v.v....>vv..>..v.v.v>>.v.vv.vvvvv>>vv.>...>..vvvv.>...>..>>>>>.>..>>v.>vvv>.vv..v>v>vv.vv>..
.....>v.>.v.v.>v....vvv.vv....vv.v>..v>vv>>....>>.>>...>>....>..vvv>>..v...>.v..v..>>>..>>..v.>>.>.>.>.v.v>>.>>..vv>v..>>>>vv.>...>...>.>>.
.>..>v..v.vv.>.>>>v...>>...v>.>.v..>....>...>.vvv...>v>...>.......>>.>vvvvv.vv.>.>.vvv.>.vvv.>.v..>.v>v.>vv.vv>.>>.v.v....v>.>.v>>..>...vv.
>v...>v.>..v..>>.v.>.v>v>v.v..v...v>.v>.>.>..>v>>v........v..vv>vv.v.>.v.vv.v..v>.v.v..v>........>v....v....v.v>..>>v>>.>..>.v...>vv>..>v.v
.vv>..>.vv.vvv.>.vvv..vv.>..v.>..>vv....>>v..v.>..v>>>..vv.v.>..>>v.v.>.....v..v..v.v...>>.....vv.vv.>..>.>v>vv>.>..>.v.v..>.v..vv.v..v.>>.
.>v..>>...vv>v...v..vv>>v.>.vv...>v.v>.v>.vvv>.>>.>..>>>.....>..>..>......>v.>..>..v..v....v.>.v>v.v...>.v.vvvvv.v>>>...>.v..vvv>>...vvv.v>
v.>>..v>.v.v.>>>.v>>>>>v..>....>.v.v>....v.>.>.>.v..>..>.....v....v.>v....>.>.v....vv>..>..vv..>..v.v.v>v..>.v>.....>v>vv..>>....>v...v>.>.
>......>>......>.v>..v>v.v.>.v...>.>.>....v.vvvv>v>>>v..vv>vv.>..v>....v........>>>v.v>>...>.vv>>..v>....v>>..>v....>v...>>>.>.........>..>
.>.vv....v.v.v.vv.>vvv.>vv......v>v.>.....vvv>.....>v.>v>.v....>..>.>v.>..>..>v.>...v.v..>>.v....>.v.>v>>>v.v...>.>.vv.>.v>>...v>>v>vv.>vv.
.vv...>.>>.>..v..>.>>..v..vv..vvvv......>>v.v.v>...v>v.....>vv>.v.....>>..>.v>.>....v.>.>.>>>...v>v.>..v..v...vv>>......>.>vvv>v.>vv.......
>.v.>v..>.v.....v..>.>..>>...>v>>>...>..>vv>>>.v>vv.>vvvv.>.v>v.>v.>.>...v..v>v..v..v..>>..v..v>vvvvv.....>vv.v>..vv.>vv..vvv...>>v..v>>.>.
..>v.>.>v>.>..>....vv..v>.>vvv.v>...>.>.v>.>>>v.>.>v>v.......v>..v>.>>>..v..vvv>...>v.>.>>..>vv>vv>vv.>.v..vv>.v>vv>>vvv...v>>...v.>..>v>.>
..>..v...>>vv>..>.>...vv..........v..v...>...>.>vv.vv.vv..v>.v>.vvv.v.>>v..vvvvv>...>.v>.>vvv>>...v.>>.v...>....>v..v>v>.>>..v...>.....>..v
....v.vv.v.>.>.>.v.vvv.>.>.>.....vv...>..>..v>.v..>>.>.v>.v>......vv>.v>>.v.>.v.v.>...>>.....>>vvv.vvv.....>.v..>...>>v>.v>>v..vv.v...v..>.
..>..>....v.>..v.....>.>.>>.>..>.v..>vv>..v>>.>vv.v.>.vv.>..>v.v....>v>>v.v.v.v...>..v.>.v>v.v.v..v>.v>v...>.v...>>.>..vvv..v>>>>v...>vv>..
...>v.>...vvv>..v>.vvvv.vv.>>...v>.v.>>.v>v...v...>>vvvv.v....v..v.....vv.....>.>>>...>v>v.>vv>>.v..>.v.>..>.....>.>..>...>....v..v.>.v>.v>
vv.v>>v.>..v>>>..>.>....v.v...v.>...>..v....>>..vv..v>......>>v>v.v>>.v.v>....>v.>..>..v>..>v.>.v.>vv.v.>>.>.v>>vvvvv...vv>v.vv..>......v..
...>.....>v...v>v.>..v........v>vv>>.>.vv.>v....v>v>>>.v...>.v...>>>>>vv>.vv>.v..>.v.vv.>.>>v....>>..>>>..v>v>>>>....>vv..>..>>v>.v.v>....>
.vv..>..v.vv.>.>>..>.vvv>.>vv>..>.....>>.>>..v.>..>..>....v>v>>.v>>..>>.>....>.>...>v.>.>.>>.v...v.v.v>v>>>>..v.v.v..>.>>......v...v>>.>>..
.>v...>v>vvv.>.vv..>>>v..v.v..v.>.>v...>v.>>.v>v...v>v>...>.>>v>v>..vvv.v.vv.vv.>>..v.>>......>..>v..>..>v>>v.v.>>.>.......v>.>.>>>v>>.>>v.
..v......>>>v.>..>.v>..v>>....>>>.>v....>..vv>.>v.>.v...v>>..v......v>>.>..v>.>>>.>vv>.....>>..vv.>v...v.....>..v>>>>...>.v..>....>..v>>...
....>..>..vv>.>.>.>>....>>>>v.>v>..v..v.vvv..>..>...>..>>.>v.......>..v.v>>.>.>v>>.>.v.v>>>..v..v>>...>...v>v>..>.vv>>.v>.>v...>>v>.....>vv
..v...vv...v>v>.v....v..>>>.>v...>v>...>>.>...v>..v>.v.>>>v..>vvv....>...v..v..>....v...>.v>v...>>.>...>.>vvv...v.>>.v.v......v>..>>.vv.>>v
v...vv..>..>v..vvvv........v.>.>..v.....>.>....vvvv.v>v>v>>v..>v>v.v>.>.>v>....vv>...>.>.v>>....>>v.v...>..>>>vv..v.vvv>.v.>v>v..v>.v>....v
.v.v>>>v.v...v.>v.>>v..>.>vv..>v........v.v...v>>.v.vv>v.>v.>v.>.>.>.v.>>...>vv.vv...v.v.>v.>....v.v>..vvv..>.......>.>vv>..v>..>.vv.....v.
>>.v.v>>v>..v...>.v>..v>.>.>..v.v..v>.v...vv..vv.vv>..v.vv.>v>>v>....>.vv.vv.vv....v.v...v>>v..>.v..vv.>>>>>.>v>v.>>......>v....v>v..vvv.v.
>..v.....vv>v..>......v..v...v..v>.>.>v.v>....v.>....v>>>.>v>.v.>..vv..>......vv..>.vvv...v...v..>.>...>v..vv..v>..>.>.vv...>v>...>...>.>>.
>..v>.>v..v..vvv.>>....v....vv.v.vvv.vv>>>v.........>>.>...v>.v>vvv..v.>>.>.v.>v>.vv..>..>>.v.>>>...v....>..v>..>.>.vv....vvv>......>..>.vv
>v..v>.>...v...>>.vv..v..>..>.>vv>>>>vv>>.v.v..>v>vv>...>v>vv...v>vv.v>v>>>..>...v>>>.>.>..v..v>>vv.>>vv..vv.....>v.>..v....>...>.v.....>>v
>>vv.........v>>..vv.v.....>v.v..v...>.vv...v..v>.v...v.v.v..vv.vv....>.v>vv>vv..>vv.v.v>v>>.>.v.....vv.v>..v>v..v..v..>..>>v....>v.>v..>..
.vv........>v...>..vvv.>v..vv>.v>..vv>vv>vvvvvv....vvv.>.v..>>......v..>>v>v.v>.>.>..v>.>...>vv...>>..v.vv>.v.>>v.>v..>.....v...>.v.>..>..v
>.vvv.>>.>....>.vvv>>v..>v>.>vv.>>.>>vv>vvv.>.v>>v>.>>>..v.vv.>>>.>.....>..>vv>>>.v.v...v>>v.v.v>.>.>>v>>.>vv..v.>v..>v..v..>>..>.>.vvv..v.
>>..>>.>v.>v..>..>vvv>v...vv>..>v.....v>v.>v.v.v>..>......>.v>.vv...v.....v.......>...>.v>v>vv.vvv>....v.>..v..>vv.>>>....>....>...>>.>v>vv
.>.vv...vvv.vv>vv...vvvvvv>..v..v...v..>v...>.>.>.v..v..>v>v....v>.vvv>.v.>vv..v.>....v>.v>>>.vv>.vv>....>..v..>v.v.>>v..>v...>v.v>>.>.>v..
.>>v..vvv.>..v>...>v>vv...>>..v.v.>>v>..>.>vv...>...>.>..v..v.....v....v..v>>vv>>.vv...v>>>...>>.v....>>....>>>.>>>>.v>...>.>>..>..>v...v>v
...>>v..>...>vv.>v>v>vvv.>.v.v>..>vv.v>...vv.>..>.....v>..v>..v>vv.>>>..>>v.v.v.......v.>..v..>.>v>>....>.>v...>.v>.>..>v..>.>...v>v...v.v.
.....>...v.v>v.>v..>.>.....v.>v.>...v>>v...v......>vv.v.>>.v..>>.>.>>.>>v......>......>v>>v>>>>..>.v>vvv>.......>.v.>vvv..>v...>>>..v>vv.>.
v>v......>...>.>.vv>v.>>.v>....>>...>v>...>...>v.>....v>.>..>>.vvv.>.>v>>.>...v.>v>vvv>.>vv..>..v.>.v.....>v.vvv.>v....>>vv.>.....>>v.>>...
.>.>>....>vv>.>>v.vv.>..v>>...v>v..vv..>.v....>>v..>.>...>>..>vv.v.>v..v...v>.v>v.>..vv...v.v>..v.>v.>v>..>>>...>>.>>>.vv..v>v.v>..>v>>v>v>
.>.vv>.>vvvv.....>>>.vv.v.v..v>>...>..v>>>>>>...v>>>..vvv..v.>.v.>>.>v..>>...vvv.>>>..>>vv.v.>.>..v>.v>.>..v........>..v...vvv..>.>..>vv...
.v>.vv>>.vv......v.vv...v>.>vv..vv...v...v...>.>.>>vv.>...>>vv>..v>...>....vv..v..vv>v...v.>>.v>v>..v.>v.>v>>..>.v>>.v...v>..v>v..v......v.
v..>>.>vvv..>v>>>..v....>.vv.>>>>v.>.v.v.vv..v>>vvv..>>>>>.........v...vv.v...>.>.v>v>..>>>.v.v>>>.vv>.v.vv.>vv.>.>vv>>vvv....v.>..v>>....v
v....>.>......>>>.>.....v.v.>..........v>.v..>.....v.>v..vv>>.>v..>v>.....v.v>v.v>>>.>...>>>...v.....v..v>v>..>>v..v>v>.v.v...v>....v>..vv.
.>.vv>.>.vvv.>.>.>....v.>.>v>.......>v.>.v>v>>.>>.>v..>.v...v.v.>.>v.>...>>v>v>..v...>..v>...>.v>v.v>>...v>.>>.v.v>..>v...>>>...v.>.>>>....
v>...v>..>v>>v.>v....v>.vv...>>.....>.v..>.>>....>v.>..v>v>.>>.....>>....>.>.>.v>.v.vv>...v.vv>>>>vv...vv>vv>.v..>>..>>>..v.>.>>>.>..v>v>>>
>..>>>>..>>.>...v.>>.>v..v...>v.>>v.>.v.>v>.vvvvvv>v>......vv.>vv...>vv..>v>>>v.v..v..v.v>>v..v..>>.vv>..>v...>.v.v.>>v.>....>....v>.>>>.>.
>v.>v......>.vv.vv>>v>.>.....v>.>.v..v...v.v..v>..v..>>>>...v.v....v...>.....v>.v.>.....vv>.v...>vv.>..>>.vv>..>...v..>.>>>..v....>>>>v>.v.
..v>..v..>vv..>>vvv>vv....>..v.v>>vv..>v..v.v.v>>>v.>>.vv>vvv..>v...>>.>..>v....v.v..vvv.>..>.v..>.v....>>...vv.vvv.>.>>.>v.>v>v..>.>>...v>
..v>.>v.>.vvv.>v..vv>vv..>..>v.>v.vv>>..v...>.>...v.>.>..>...>v>.>..>.>.>>>>>>.v.v..........vv...v>.v>>....v..>>>.vvv..>v.v.>>.v.v>.v...v.>
>v>.>>..v>>..>>...>v.v....>>....v.>>>vvv>..>..v>v.>v.v..>.v.........>..vvv.vv.v..v>.>vv>..v..v>.v..>>..v.>..>....v..v..>>vv.v.v>>>.vv>vv.>v
vv.>.v..>>>.>vvvv>v..v...v>.v..v.v>>vv>>...>>.v.>>>>vv.>v>vv>>.v.v.v>>....>...v..v..>vv>v..v>>v.>>>v>.....v.v.vv>vv.>v.v.v..>>..v>>v>v.>...
..>>...v...v>>..>...>v>...>.v..v.>.vv.....vv.>..>v>..vv.v>......v>...>>>..>.>...v...>v.>v.v..>>...v....vv>..>>...>.v>.>.v>..v..>>>vv>>..>.>
>.....v...v>v>.v.>..vv......v>.v>>>v..........>.v>vv>v..v.>v.vvv>>>...v>v>>.>..vvv.>....>...>v..>.>.v.v..>.v.>.........vv.v>>..vv...v...v.v
v..>.>v.>..vvv.>.>>....>>v.v..vv.vv.v..vv..v......>...>.>>v>v>..vv>...vv.v.>>.>.>....v.>..v.v.v>....>>..>>>..>.v.>.v>vv..>>v...>.v...>v....
vv.>..v>>..vv>.vv.>.>.>.vv.....v.>v.....v>>....>v.>v.v.....v>vv.v....vv..>>>..v>.v...>......>v>.v.v.>>.>..>>v....v>>>>.>>.>v........>.>.vv.
..>.>>.....>>.vv>>>vv.>..vv>..v..>..vv.>>....vv.v>>>..vvvv.>.>.>..v>vvv..v>.v......>.>v...v>>.vv.v>....v..>>>v.vv.vv..v.vv....vv..vv>..vv.>
.vv.vv>.>.>v.>.>..vv.vv>.v.....>.>>.vv.>vv.>.vv>>.>>.>>>>.>...v.>.v>>.vv.....>.>..vv>v>..>v..>.>v..>vvv.>vv.>.v>vv>>...>v..v>..>v.>......v.
v..>v......v..>>.v>.vvv......v>..>v..>.>..>..>.vv.....v...>>..v>vv.>>>v.>.v>..>...v>v.........>>.v.vv>vv..v..v.v>>.>v..>..>v>.>v>....v.>.vv
..>>>>>..v>>v>..vvv..>vv.vv..>...v.....v........vv.v>.>.>...vv>v>.>..>.v.vvv>.>v.>>......v>v.....>....>..>v..>.v....>.v..>..>>.v..v...>>.>.
v.v>.>...vv>..v....v..vv>........>v.......vv>....>...vv>.>..>v.vv...v>>.>>vvvvvvv.>v>v..v..>.>.>...>v..>>>v>v.>..>v..>v...v....v>>>.>....v.
>>...>...v.v..v.v.v....v..vvv>..>.>v.vv>.vvv..v>.>v..v...>v.>..>v>v....>v..>..v..>>>>.>v.v.v.....>v..v.v>v..>.>...>...vvv.v>v>>.v>.vvv.>..>
..v>.v.v.v>v>>v.>.....v>>v..v>..>>>>..v..>.vv>.v.>.v>v>..v>...v>.>.v>vv.vv...>>...vv...v..v.>>.>..v>.>vvv>......>.>v>..v......>.v..vvv>.>v>
vvv.v..v.vv.vv>...v>v>..>.v..>v.>.>>.>....v>v..v.>....v>.v....vv>vv..v.>v>...>>>>>v>>v.......v>>v.>v...>>.>v...vv.>.>vv..>..>>.>.v>v.v.v.>.
>>>.v>>>...>.>.v..v..v..v>v>.v..>>v>..>>v>>vv..v.>..v>.>>....>vv>.>v....v>v>vv...v....>>.>.vv..v>v..v>.>..>>.v..>v.>v...>>>v....>>>>>....vv
v>>.v.v..>v..v>>v......v>>>.v.v>.vv....>v>..>>>v>>..>..>>..v.>..v.>>v..>>>.>vvv.>v..vv...vv..>..>v..v.>.v..>.v>vv....>>>v.....>.>v..>.>.v.>
..v.v>...v>...vv.>..v......v>.v>..>>.>>v.>..>...v.>.v..>>...v.>.v>.>..>>v>v........v..>v.>v.>..v>.>>....>..>>..vvv>vv...vv..>.>>....>.>..vv
v>.v.>vvvv.v>.>v>>.>v..v.v...v..v.v>....v>.>.>>.>.v..v.vv.v>...>....>v..vv.v>v.>v.>>.>v>.>>vv>.v...v..v.v>.>v...v.>v.vv..>>>......v.v>.v.v.
>v.>.>...>v.v...v>>..>..>...v>>>>v>.>>..vvvv...v>.v...v..vv.v.....>vv.v.>v...v.v..v.>vv>.v>........>>.v>v>.>>.v>>>.vv..>vv..>>........v.>>>
>>...vvv....>>.>>>..>.....vv.v...v........>v>>.>vv..>.v.>.>...v...v....>v....>.>>>..vv..v..>v>v>.....vv...>.>...>>.v.>>.v........v>...>..v.
>.>.v.>>>v>.......vv>...>...>.>.v...v.vv>>.vv>..>..>v..vv>.v.v>vv.v..>>v.>.v.....v..v.v....>v.>v>v.v>v..>.v.>>vvv>v>.v...v>..>v...>v>.>...>
v..v..>.v..>.>v.v>.>vv.v.v>>.v..v>..>v>v..>..>>>....>vvv>.>>.v.v..v.>..v.......v..v.vvv..>v....>......>>..>..v>>>.>v>v>..v....>>..v.vv....>
.v.>.>v>.vv>v...v...vv..v.v....>...>.v>..>.v>.>...>.v.v...>.>.vv.>.....v.v.>vvv>>>v.....v.>.....>>...>.vvv...v>..>v>v.>>.vv>>....>..vv..v..
>>>....>.v>>>>.vv>.>v>>v>>..>>....>v.>...v.vvv.v>v..v>>v...vv>.>>v....>v.vv.v.....>v>>.v....v>>..>..>..>v.vv.vv....>...v>>>>..>>vv..v>.>v>.
>.>..v...>...>.>v...v....v..v..v.>vv>.>.>.>v.v>vv.>v>v..>..>>>.v.>....v>>v.....v....>....v....>.>..vv.v.vv.>.v.>vv.>>>.vv>>.vv>v..>v.....v.
>>.>.v.....>>.>>...>..>..>..>v>...>>>v>>>.v..>>>...vv...v.vv...>>.v.v.......>vvv>..>.>..>.>.v>vv...>.v>..>>.v.>v.v.>>>.vv..>v..v..>.>>..>v.
...v.>v.v......vv...v..>...v.v>v>>...>>.vv.>.....>...>.vv>.>...>>>.v.>v.>.>.>>...>.v..v.v>v.>..>...>v.vv.v...>.>>......v>..>>.v.v>>.....>v.
.>.vv..vvv.v.v...>.>.vvv...v>..>.>>.v..v...>..>.v..v.>.>>..>v..v.>v..>...>v>.>..v>vvv..>>v>v...>>.>v>.....>...v..>..v.>v>.>..v.>v....>....>
>..v>...vv>..v.v>>>..>...v.>.>..>>>v..v>.>vvv..v>..vv..v..>>>..>..v......v>v.vvvv>..>..>>.v>>vvv.v.>....>...v>>>vvv.vvv.vv>>.>vv....>.v...v
.>...>.>v>..>.v>..>vvv..v>>.v.>>v...>.vv.v....>v>vv>..>>..v.v.vv>v>>v.>.v..v.>.>v.....>..vv.vv.>v.v.vvv...v....v.....v..>>...vvvvvvvv>>.>>.
.....v>>..v.vv>v>v..>v>..>....v..v....v..v...vv...>>v>>.>v>.>>>v.v..>>.>>...>>.v>vv.>v..>vv.v>>....v>>.>..v...>v>..vv>..v..>...v.>vvv...v>>
>.vv>>v>>>...v.v........v>vv..v>..v..>....v.>vvv.v.vvv.>>.>>>..v.>>.vv.>>v.>..v>v.v.........>>>vvv>>.vvvv.......v..vv...>...v..>v>>......>.
......>>>.....>>.>>..vv>.>..vvvv.v>>.v...v>...>.>.v..v...v.v...v....v>>>v..>>.v>v.....vvv>vvvv.v......v...>.v.vv>v>>>>v>...>v>.vvvv>..v.v>.
>>.>v..v>..>.....v.v..>....>>.v...v>...>.v>v>v.>..>v.vv.>>.>...v..v..>v.v.vvvv>.vv..v..v.>....vv.>..>.vvv>.>v......v.>vv>..>>vv.>v.>vv..v>>
>..>.>.>vv.vv.>v.vvv.vv.>v....>>..>>..v.>>.>vv.....vv..v..vv..>v.>..>..v>v.....>v...v.>.......v>.>...>.>vv>.vv>vv..v>...v>vv.v>>vv..v.>v>>v
....>>.v..>.v...>.v.>>.v.v.>>v...v.v.v>>...v.>..v.v...>>.....>.v..vv>>.>.>.>v.v>v...>..v>..v.v>vv...>v>..>..v....v.v....>v.>v.......>..>..>
..>.v>>..>.>>.....>v>..>>..v....v>v.>v>v>..>.v.v...v.v>>v>>>>..v..>..>>vv....v..v.>..>vvv>>>..v.vv>v..v..v.>v>.>.>>.>.....v...>v....vv.>..v
v..>..>....v>......>v.vvv>vvvv...v...>...v>..v..v>...vv.>>..>.>.>.vvv.>.....>...v>>.>vv.>>....>.v....v.v>>.v>...v>.v..v.>..v.v.>.>.>.v>.v..
>>>......>..>.....>>..v.v>....v>v.v...>v..v.v....>.>.vv>.>..v.>.v.vv....>...v.>.v.v..>.v>.>.>.>v>>>>>>>..vv.>v.v.>.v..v.vv..>.v.v>vv..v>..>
v..>.v......vvvv....v..vv...v..v...>....vv.>v>.>..v..v.>>.>v>v..>v..v.vv.v.v>.>.....>vvv.v>>..vv>.>.v.....>>>vv..>>>..>v.>.v.>v.>vv.>.>.>v.
.v>vvv.>.vv.v>vv.>v.>.>v>.>.vv..>.v.....v.v.v>>v>v.>...v.>..v...v.vvv..vv..>>v.vv.>.....v>>vv.>..>..v.vv..v..v>vv.v.v.v>>..>>..>>...vv>...>
..>....>.v.v.v.v.>>........v>.v>vvv.v.>..v.>...v.v..v>v.v>v...v>>v>>.>vv....>vv.vv.....v>>>v...>..v....v..>.v>>v...vv..>>..>.v..v>...>....>
..vvv.>.v>>v.>..v....vv..vvvv.v.>>.....v.>v>v.v.vv>>.v.....>.v>>v.v.v.v....v..v......v>v>.>vvv..v>>...v.....v>..>.vv>>>..v.>.v...>>.......v
>.v.v>.>v>.>.v..v..v..>vv...v>.vv..>.>v.>vv.v.>....v.v..>v..>v.v>....>.v>.v.>>..>v.>.v..v.v>...>v...>v>...>>.....v.>.>>>vv>v>.v>>vv.v.>..>.
v...>vv>>...>v.>.>.>vv>..v>v.>..v..>>....>>.v>>v...v..>>.v.>..v.v.v.v..v.v>v....>.v>.vv..>>v>v.v>>..>v>v>v...>vv.v...v...v>..>>>.v.......v.
