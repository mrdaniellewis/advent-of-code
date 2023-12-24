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
SIZE = XRANGE.max + 1
START = start

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

def walk(r)
  distances = Hash.new { Float::INFINITY }
  distances[START] = 0 if r.even?
  heads = [[START, 0]]
  loop do
    heads = heads.flat_map do |(head, distance)|
      distance += 1
      next [] if distance > r

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

    # puts distances.values.tally

    break if heads.empty?
  end
  distances
end

period = (count - (SIZE / 2)) % SIZE
iteration = count / SIZE + 1

sizes = []

7.times do |c|
  test = (SIZE / 2) + c * SIZE + period
  distances = walk(test)
  # puts debug(distances)
  pp [test, distances.size]
  sizes << distances.size
end

polynomial = (0..2).each_with_object([sizes]) do |_, sum|
  sum << sum.last.each_cons(2).map { _2 - _1 }
end

pp polynomial

values = polynomial.slice(0..-3).map(&:last).reverse
add = polynomial[2].last

count = 7
until count == iteration
  values = values.each_with_object([]) { _2 << (_2.last || add) + _1 }
  pp values
  count += 1
end

pp values.last

exit

r = 0

puts debug(distances.map.select { _2 <= count }.to_h)

exit
distances.map.select do |(pos)|
  XRANGE.include?(pos[0]) && YRANGE.include?(pos[1])
end.select { _2 <= count }.then { pp _1.size }

[1, 2].each do |t|
  (DIRECTIONS + DIALOGONAL_DIRECTIONS).each do |dir|
    c = distances.map.select do |(pos)|
      pos -= (dir * SIZE * t)
      XRANGE.include?(pos[0]) && YRANGE.include?(pos[1])
    end.select { _2 <= count }.size
    pp [dir, t, c]
  end
end

exit

loop do
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
  puts "count=#{count}"
  puts "total=#{total}"
  puts "size=#{XRANGE.max}"
  full = [(count - XRANGE.max - 1) / (XRANGE.max + 1), 0].max
  puts "full=#{full}"
  puts "full_count=#{(full + 1)**2 + 1}"
  # puts debug(distances.map.select { _2 <= count }.to_h)
  # pp [r, count, (r + 1)**2, (r + 1)**2 - count]
  diffs << (r + 1)**2 - count

  if r >= XRANGE.max / 2 + 1 && r < (XRANGE.max + 1) * 3
    # Start collecting ends
    DIRECTIONS.each do |dir|
      c = distances.map.select do |(pos)|
        pos -= (dir * (XRANGE.max + 1))
        XRANGE.include?(pos[0]) && YRANGE.include?(pos[1])
      end.select { _2 <= count }.size
      counts[dir] << c
    end
  end

  if r > XRANGE.max + 1 && r < (XRANGE.max + 1) * 4
    # Start collecting ends
    DIALOGONAL_DIRECTIONS.each do |dir|
      c = distances.map.select do |(pos)|
        pos -= (dir * (XRANGE.max + 1))
        XRANGE.include?(pos[0]) && YRANGE.include?(pos[1])
      end.select { _2 <= count }.size
      counts[dir] << c
    end
  end

  if r >= SIZE * 3
    puts debug(distances.map.select { _2 <= count }.to_h)
    break
  end

  r += 1
end

pp counts

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

# x
# + 4y
# + 8x
# + 8x
#
# 0  1
# 2  8
# 4  16
# 6  24
# 8  32
# 10 40
#
#
# 1 + 2*4 + 4*4 + 6*4 + 8*4

total = 1
cursor = 2
while x < target
  total += x * 4
  cursor += 2
end

# (c - SIZE / 2) % SIZE
