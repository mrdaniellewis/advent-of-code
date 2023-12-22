# frozen_string_literal: true

require "matrix"
require "colorize"
V = Vector

start = nil
count = ARGV.shift.to_i
GRID = ARGF.each_line.map(&:chomp).each_with_object(Set.new).with_index do |(line, h), y|
  line.chars.each_with_index do |char, x|
    h << V[x, y] if ".S".include?(char)
    start = V[x, y] if char == "S"
  end
end

XRANGE = Range.new(*GRID.map { _1[0] }.minmax)
YRANGE = Range.new(*GRID.map { _1[1] }.minmax)
RIGHT = Matrix[[0, -1], [1, 0]]

def debug(distances)
  yrange = Range.new(*distances.keys.map { _1[1] }.minmax)
  xrange = Range.new(*distances.keys.map { _1[0] }.minmax)
  yrange.map do |y|
    xrange.map do |x|
      pos = V[x, y]
      v = if distances.key?(pos) then distances[pos] % 10
          # elsif GRID.include?(V[x % (XRANGE.max + 1), y % (YRANGE.max + 1)]) then "."
          else
            "."
          end
      v = v.to_s.colorize(:red) if (x % (XRANGE.max + 1)).zero? || (y % (YRANGE.max + 1)).zero?
      v
    end.join("")
  end.join("\n") + "\n\n"
end

DIRECTIONS = [V[0, 1], V[0, -1], V[1, 0], V[-1, 0]]

r = 0

diffs = []

until r == 100
  distances = Hash.new { Float::INFINITY }
  distances[start] = 0 if r.even?
  heads = [[start, 0]]
  count = r
  loop do
    heads = heads.flat_map do |(head, distance)|
      distance += 1
      next [] if distance > count

      DIRECTIONS
        .map { head + _1 }
        .select { GRID.include?(V[_1[0] % (XRANGE.max + 1), _1[1] % (YRANGE.max + 1)]) }
        .select do |pos|
          if distances[pos] > distance
            distances[pos] = distance if (distance.even? && r.even?) || (distance.odd? && r.odd?)
            true
          else
            false
          end
        end
        .map { [_1, distance] }
    end

    break if heads.empty?
  end
  total = distances.map.select { _2 <= count }.size
  puts count
  puts total
  puts debug(distances.map.select { _2 <= count }.to_h)
  # pp [r, count, (r + 1)**2, (r + 1)**2 - count]
  diffs << (r + 1)**2 - count

  r += 1
end

diffs
  .each_cons(2)
  .map { _2 - _1 }
  .tap { pp _1 }
  .each_cons(2)
  .map { _2 - _1 }
  .tap { pp _1 }
  .each_cons(2)
  .map { _2 - _1 }
  .tap { pp _1 }
  .each_cons(2)
  .map { _2 - _1 }
  .tap { pp _1 }

exit

puts debug(distances.map.select { _2 <= count }.to_h)
pp distances.map.select { _2 <= count }.size

# (-4..4).each do |y|
#   (-4..4).each do |x|
#     filtered = distances
#       .map
#       .select do |p, d|
#         XRANGE.include?(p[0] + (XRANGE.max + 1) * x) &&
#           YRANGE.include?(p[1] + (YRANGE.max + 1) * y) &&
#           d <= count
#       end
#       .to_h
#
#     # pp [x, y, filtered.size]
#   end
# end

(count + 1).times do |r|
  ring = distances.map.select do |p, _d|
    p -= start
    p[0].abs + p[1].abs == r
  end.to_h

  pp [r, ring.size, (r + 1)**2]

  next if ring.empty?

  # puts debug(ring)
end

# pp distances.select { _1[0] == 0 }
# pp distances.select { _1[0] == 0 }.sort_by { _1[0][1] }.map { [_1[0][1], _1[1]] }
# pp distances.select { _1[0] == 1 }.sort_by { _1[0][1] }.map { [_1[0][1], _1[1]] }

# Even 1 + 8 * 1 + 8 * 2 + 8 * 3 -> 1 + 4 * n ( n + 1 )
# Odd  8 * 1 + 4 + 8 * 2 + 4 -> 4 * n ( n + 1 ) + 4 n

# 4 + 11 + 16

# See how a shell changes over time
# Are the shell sizes consistent by their mod distance from the center?
# Do we need to take account of the distance from the edge?
# Can we sum the shells or are there too many
