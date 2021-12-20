# frozen_string_literal: true

require "Set"

$enhancement = ""
in_enhancement = true
current_y = 0
image = Hash.new { Hash.new { false } }

DATA.each_line.map(&:strip).each do |line|
  next in_enhancement = false if line == ""
  next $enhancement += line if in_enhancement

  line.split("").each_with_index do |char, index|
    image[current_y] = image[current_y]
    image[current_y][index] = true if char == "#"
  end
  current_y += 1
end

flip = $enhancement[0] == "#" && $enhancement[-1] == "."
pp $enhancement
puts

VECTORS = [
  [-1, -1],
  [0, -1],
  [1, -1],
  [-1, 0],
  [0, 0],
  [1, 0],
  [-1, 1],
  [0, 1],
  [1, 1]
].freeze

def debug(image, time = nil)
  yminmax = image.keys.minmax
  xminmax = image.values.flat_map(&:keys).minmax
  flip = $enhancement[0] == "#" && $enhancement[-1] == "."

  puts time
  puts((yminmax[0] - 2..yminmax[1] + 2).map do |y|
    (xminmax[0] - 2..xminmax[1] + 2).map do |x|
      next (flip ? time&.even? : false) if y < yminmax[0] || y > yminmax[1] || x < xminmax[0] || x > xminmax[1]

      image[y][x]
    end.map { |v| v ? "#" : "." }.join
  end.join("\n"))
  puts image.values.reduce(0) { |total, h| total + h.keys.length }
  puts
end

def next_coords(image)
  yminmax = image.keys.minmax
  xminmax = image.values.flat_map(&:keys).minmax

  (yminmax[0] - 1..yminmax[1] + 1).map do |y|
    (xminmax[0] - 1..xminmax[1] + 1).map do |x|
      yield [x, y]
    end
  end
end

debug(image)

50.times do |time|
  pp time

  new_image = Hash.new { Hash.new { false } }

  yminmax = image.keys.minmax
  xminmax = image.values.flat_map(&:keys).minmax

  out_of_range = flip ? time.odd? : false

  (yminmax[0] - 1..yminmax[1] + 1).map do |y|
    (xminmax[0] - 1..xminmax[1] + 1).map do |x|
      count = VECTORS.map do |(xd, yd)|
        xn = x + xd
        yn = y + yd

        next out_of_range if xn < xminmax[0] || xn > xminmax[1] || yn < yminmax[0] || yn > yminmax[1]

        image[yn][xn]
      end.map { |v| v ? "1" : "0" }.join

      value = $enhancement[count.to_i(2)] == "#"

      next unless value

      new_image[y] = new_image[y]
      new_image[y][x] = true
    end
  end

  image = new_image
  debug(image, time)
end

puts image.values.reduce(0) { |total, h| total + h.keys.length }

__END__
#####.##....##....##.#.....##....##..########.#.##.#.#.##.#..##.#.####.######.#####.######.##..#######.#.#...#..#.####..####...#.####..#......#...#...##.#.....#....#..###.#..##....#.#....#...##.###.#.#..##.......####.........#.#.###.#.#.....#..##..##.#.##..###.##.###.#....#.#..##.#.......###..#.#.#.#.#.....#..#.###.##..##...#....##...##.##...##.#..####.#...#.####...####..#####.#####.#.##...#.###.#######.###..#..##.#.#..#.#.#######.#####.#.##.#.#...##.######.#...##.##.#.........##...##.....#.###.#.##.#.####.

..###.#.#...##.#....#..##....##.#.#......#.##.##...###..#.##...#..#......#..#....###.###..##.#..#.##
.#...#..#.##.##....###.##.######.#.##..#..#..#.##.#.###.#..#..##...#..##...######.#..####.#.#.#..##.
.##.#.##.#.....###.#.#...#####.#.#.#....#....##...#.....##.#...##....##.#.#.#..##.##...#..#..#..#..#
#.###.###.#.#.#....##.#.....#.#.#.#...#.#.#####....#.#.##.###..##..#..#.#...#.....#....#.###.#..#...
#.#.##..#..###..##...####.#....#.#.#.###.##..#....##.#..##.#...####.....#.#..##.##....######..##.#..
.#..#..##..#.#.##.####..#..#..##.#.#..##.##.###....#.#.####..#.#.####..##.###...#..#.#....#..#..###.
..##.#####..#...##.#...#####...#.##....##.###...#.#.#.##.#.####.##..#.#.#..###...#..####......###.##
....#......###.#...###..#####.#.##.#.#####..####..##...#..#.####.#.##########.######...####.###.####
###.####.#.###.#..#.##.#.#.#.####.##...##.....#..#.###..####..#.#.#..#######..###.....#..##...#....#
.###.#.#######.#..###.##..#.#..#..######......##.#.##..#....##...#....###.######.#.#.#.......##.....
#...#.####....#...#.####.##..#.#####.#..####.###.#...##....##..##.#.##..#.###.##..###..##..#.#...##.
..#..##.##.#..#.###.......#..###...##.###..#.##.#...##...#..####.##.######..#.#.#.#..#####.#########
####.##..###..###.##.#.####.##.....#.###..#..##.#...###..#.##...#...###.######.##..#..#####..#.#.###
######.##...##.......#.##...#.####.#.##.#.#..##.#.#.##.#...##..#.##.##.##.####.####..##...#...##.#.#
#.##...##...#..#.##.#.##.#####....#.##.###..#####.##.###.###..##.....#####..#...#..#.#.##.##.#.##.#.
.##.#...#.#..###.#.##.#..#.....########...#..##..##..##..###.....##...#.#.##.###.#.#####..##..##..#.
#.#.#......####...#...###..##.##.#.##.#....#.#.######...##.#...#.##.##..#...####...#...##.#.####.##.
#..###..#.....#..###...#.#.##.######....#.#...##..######.#.###.###.......###...#.....#####.....#.###
#.#.##...##.###..#.###.#.##..##.##..#.#.########........#####.#.###.#.##.#.###.#..####..#.#..##..###
#...##...###.#.#.##.....#.##.###.#..##..#.###..#.#.##.#.##..#..#.#...#.#.#####..######.#.#.##..#.#..
#####.#....#.#..###.#....#.##..#.###.#.......###..######..#.##.###..######.#.##.#..######.##..##.#..
##...##...###.#.###.#.####...###.######...#...#########.#.....#...##.#.....#..###..#..##..#.#####...
#.###..#.#.#.##.....#...#.#..#...##...####..##..##.##............#...#...#..#.###..#....#.#.#.#.....
.##..###.#...##...#...#####.##....#.#...#.##.#.##..##..#.##..#...##........#.....#...##...#..#.#.#.#
.#.#.#.##..#...###.####.##.......##.###..#.##.#####...#.#.#####.####..####.#####...######..#.##.....
.##...#.##..#..#...#......###....#.#..##.##..#...##.#.#..#####.#.######.####...###......#.....##...#
...#.#....#.#.#...###..##..#.####.#..##...##.#.##.....#...#.#.#....#.#.##.#..#....#.####...#.....###
##....#.####........##...#..###.#.##..##..#.....####.#.###.##.#.##....###.##.#..##.###.##..##..##..#
#..##.....#....###.##....#.#.....####.###..####...#.#####..#.#..##..#.##.#........#.#.#.##.###.#.##.
#..######.####..##...#.#...#########...#..#...###..##.###.....#.#..##.#....#..#.#.#.........#..#.#.#
##.....#..###.##..##..#.#..###.#.#.##.###....#.##....#.###...#.#.##.#..#.#.###.###.##....###...#.##.
....#####.#......#..###...##.#........##..#.#####..#.#####...#.##..##.#..#..#.#.#....#..#..#...###.#
.###.##.##......#.###.#.#.##..##.#..#.#.#..#..#...##.##..#.########.##..##.#.#..#...####.###.##.##.#
.#.####....#..##.#.....###.##.##..#.##...#.....#..#.......#.#..#..###.#..###..##.###..##..#.##...#..
#.....####.###..##.#....#####......##.#..##..##.#####....###......##.#...##.#.#...#####..#####.####.
..###..#..##...##.#.####...#########.###.#.#.##...#..#..##..###.##.#..###.#.#..##.....#.#..#.###.#..
###...#.#....##.#..#....###......#######..##.####.#.##.#.#.#..#....##.##....#..#####.##.#....####..#
...##.###....#..#....#.#.#...##.#.#.###.....##..#####...#.###.##....##..###.##.##.###..#.##..##.##..
#.######....#.###..##..#.##..###.##...##.#.###.#.#....#.#######..#...#..#.#..#...#.#..##...##.#...##
.##.#...##.###.#..##..#....###.#..###..#....#..##..#.#....#.####.#.#.#.#########.#..###.#..#....####
...#.##..#####..#..##..#.##.####...###..###.#.#.#.#.##.###.######.#.#..#...###.##.#...##.#.#.#.###.#
#..####...#####...#.##..##..##.#####..#.#.##.#...#..#.###.##...#.#.####.##.######..#.##....########.
#.#.###..##.#.#..#.#..#.#########.#.#...#..##.#.#..##..#.#.###.#..#.#####.##.#.##.#.##......###.##.#
.#.###..##.##...####.##..##..####.....#..#.....#..#...##.##.#...#..#..#....#####....#.#..#.##.##.##.
.#.#.##...##..#.####.##..#.....##.##....###.##.....#..#.######...##..#.#...#####...#..#...#.#.###.##
.##.##.#.##.....######.#.#.....##..##.....#...#.#.#..###.#.#.#....#.#...#..##.##.#...##.#..##..###.#
.#.##...#.####.##..#..#.#....##.......#.#.###.##.#.####.##.#.##.#...#.#.#.#######.##....#..#.#.##..#
......###.#.#.##.#####..####...#...#.##....###.#####..##.##.......###..#.##..#..#..#.#..##.#...###..
.#..#.##..#.#.##..#..#######.........##...###...#.##..##..#.###.#...#...#.##.#..#####...#..#.#######
.#.#.#.#....##...###..###.##########.#..#.##...##.##.....#.#.....#..##.##...##.....####.##..####.#..
.#.##....#.#....#..#.###..#.....#...#.#.#...#.#..#.#.##.##...#...###..#....#.#.#####.####.#.####.##.
..#.#.#..#########.##.#....#.###.##.###.#.#..###.#..####.#..#.#...###...##...##..#.##.#..######..#..
#.#.#.#####.######.#.##....###.#.###.###.....#.#.##.#..###..##...##.####...##.#..####.#.#.....#...##
#.##.#.#..###....#.##..######......#####.##.##......##.#.###.#...##......##.###.#.##...#.#.#.......#
#####.##....#..#####.#.###...#.###.#.##..##....#.###...#...##.###..#####...#.###.#.#.##....#.#.#..##
#.##.##....#..#.#...##.....###.#..###.#.###...#..#..##..##.#.#.###....#######.#.#...#...#.#.#..#.#.#
##.#####...#.#.........##.###..#.#..###..#.##...#...#.##..#.##......#...#.#..#..#..#..#.....##.....#
.#.##..###.#..#..###...#.##.##..##.....###.#.#.#####.##.#.###................#..#.##..##....#.#.###.
.....##.....####...#.####......#....#.####.#####.###.#..###.....#....####.####..#.##..###.##..#.....
.#..###.#..####...#..#..##.###....#.#.#..#...#.###.#...#..#..#.#..#.#...#...#.###...#.##...###.####.
#.###....#..#...#..#.#...##.#..##....#.#######.#...###.##.#.#...#.....##.##....####.#..####.##.##.#.
.##.#.###.#..#.###..#.##..#.....##..##....##...#########.#.###....###....##....##...#..#......#...#.
######.##.###.####..####...##........###.#.#...###.##..#.#....#.......##..##..#.....#.##......#...#.
....##..#.##...##....##.#...##.##..#####..######.#...###.####.#####..##...#.#.##.#........#.##.##.##
#####..#.#..#########...#####..#..#...###..##.###..##..#....#...####.#.##.#..#.##.....#..#...###...#
.#.....##....##.....##..####...#..#........#.....##.###.##.#....#.#.###..#..#.#...##.##.#.###.##.#..
#####...###.###.#.#######...##.#....#....#....#...##..##...#...#.#..###.#...#.##.....#.#..##.#.##.#.
#####....#..###..#.#....###.####.....######....######.##....#.###..###.####..#...###.#..#.########..
###......#.#...#.#.##.#.#.#..###..#.####...#.###..#.###.##.#...#..#..##..##.######..#..#.##.#.#####.
...#...#####...#.########.#.#####.......###...###.#.##.##.#...######..#.#..##.#....#..#..#.##...#..#
####........#..##..#......##...#.#.##..#.##.#.####...#.####.##.##.#.#..##..#....#...##......#..##.#.
.######...#.###..####....#.#....##.......#.#.....####.....##.#####.##.#..#.#.###..#.#.#.#..#..###.##
#..#.#.#.#..#.##....#.##.#.###....##.#..###.#...#.###...#..####.##.....#.#####.####...#.##.#.#####.#
..#####..#...#..#.#.##.#...###...#.......#....#..#..##..###.#####..#.#..#...###.#.#.##.....##...##..
##.#.#...##...###......#..#..##..###..##......#..#.##.##..##...#..#.#.#.#####.#..#..##.##.##..##.#..
#.##...#...#...###..#.##..##....#....###..#...#.###.#..##...###.##.#.#..##..####.####..##.##.##.##.#
#...#######.###.##....#..###.#.#......#.####..#..##..#.#.###...#....###.....#.#....#.#.##.....#.##.#
..#.##...#.#....##....#..#####..##.#.#########...#.##.##.###..##...##..#...###..###...#...##....#.#.
#.#.###.##....#.#.###.....#..#.##.#...##.####...###.......#.####.#.#..##...###.....##.#.####..##.##.
.#####.###.#.##..#...#....#..##..##.##.##.####...#......##.#.#..#.....#.#..##...####.##..#.##.##....
....##.#..#....#....##..#.##...#..#...###..#..########.#..#..#..####..#.###.#####..###.##.#...#..###
.####...###.#...#.#.#.#.#..#.###.#.#.#..#.##..#....#####..#..#..#.......#..#..####.##.#.#..##.####.#
.#.#.###...#..###.#..##.##..#..#..#..###..#.####..###..#.#.....#.#.#.#.##...#..##..##..#........#.#.
#.##.#.....#.......##.##...#.##...##.#.#.#..#.#####.#.##.##.#...####.#..#....#.##.###....#.....##.#.
##..##.#..#..#.##..##.##.###.#....#..#...#.##.#...##.####.#.#..##...##.#...#..#..###...##..#.#......
.......#...#.####..#...###.#.##.##..##.#.##..##.##.###..#...##..#.###.##....#.#.#..#.#######.......#
....#####.###.#.#..#.##.####..#...####...###..#..####......###..####.###..#...#.#.##....##......##..
#.##.#.#.##..#.#....##.###...#..##..#.#..####.....####.#######.#..#..######.#.#...#.####......#.##.#
.#.#.###..#.##..#.#.###.###..#..#...#.#.#.##..##..#..#..#..#........##..#.##..#.#....#..#....##..#..
.#...##..#..#..###.#####.#.##.##..#.#.#####........##..#..#....###....####..#.##..####.#.#######.#..
#..#.####.###....###....####.....#.#.###..##..#.######.#.....#..#.##.#..#.#.######....#...#####....#
#...#.#.#.....###..#.#..#.######....#.##..#.#.#.##.##.##.......#...##..###.#.##..###.###.##..#####.#
#..###.###.#..##...#.####.#.########.###.#####.##.##.####..#..######...##..#.....#.##..#..#....#...#
###..###.##.#...###.#..##....##.#..#.##..#........##..##.#..#.#..#.#...##..#...#.###.#.#.#..#.##....
..#.##.....#.#####.#.#..#......##.##.##.#.##.####.#..#..#.##..##.###.#.###.##...#....#..##.###..#.#.
.##..#..#..#..##.##.#..##.#..##.#...##...#.##........##........#.#..###.###..###.##.#...##.####.#.##
.#.########....#.....#....##...#...#.##.#....##.#.#....##.#..#.###.#####......#...####.####..###.##.
...#..#.##.##.......#.......###.##.##..###.#.#....##.##.#.#....#.##.....#....##.....#.#...#...##..#.
####..#.......#..##...#..#...########.##...####..###.###..##.#.###.#..##.###.#..##.#.#...#..##..#.#.
...##...#.###.#.....#..#.###..#...###.###.#.######.####.#...##.##.###.##.....#.##..##.#.####..###.#.
