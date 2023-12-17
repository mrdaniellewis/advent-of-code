# frozen_string_literal: true

require "matrix"
V = Vector
LEFT = Matrix[[0, 1], [-1, 0]]
RIGHT = Matrix[[0, -1], [1, 0]]

GRID = ARGF.each_line.map(&:chomp).each_with_object({}).with_index do |(line, m), y|
  line.chars.each_with_index do |char, x|
    m[V[x, y]] = char.to_i
  end
end

XRANGE = Range.new(*GRID.keys.map { _1[0] }.minmax)
YRANGE = Range.new(*GRID.keys.map { _1[1] }.minmax)
DIRECTIONS = {
  V[0, 1] => "v",
  V[0, -1] => "^",
  V[1, 0] => ">",
  V[-1, 0] => "<"
}

def debug(visited)
  visited_hash = {}
  visited.each do |pos|
    pos => { coord:, dir: }
    visited_hash[coord] = dir
  end

  YRANGE.map do |y|
    XRANGE.map do |x|
      pos = V[x, y]
      DIRECTIONS[visited_hash[pos]] || GRID[pos]
    end.join("")
  end.join("\n") + "\n\n"
end

def turn_left(pos, dir)
  new_dir = LEFT * dir
  [pos + new_dir, new_dir]
end

def turn_right(pos, dir)
  new_dir = RIGHT * dir
  [pos + new_dir, new_dir]
end

Pos = Data.define(:coord, :dir, :linear)
Head = Data.define(:pos, :total, :history)

start_x = Pos.new(V[0, 0], V[1, 0], 0)
start_y = Pos.new(V[0, 0], V[0, 1], 0)
buckets = [[Head.new(start_x, 0, [start_x]), Head.new(start_y, 0, [start_y])]]
best = Hash.new { Float::INFINITY }
found = nil

catch :done do
  loop do
    bucket_index = buckets.find_index(&:itself)
    buckets[bucket_index]
      .tap do |_b|
        buckets[bucket_index] = nil
      end
      .flat_map do |head|
        head => { pos: { coord:, dir:, linear: }, total:, history: }

        positions = []
        positions << Pos.new(coord + dir, dir, linear + 1) if linear < 10
        positions << Pos.new(*turn_left(coord, dir), 1) if linear > 3
        positions << Pos.new(*turn_right(coord, dir), 1) if linear > 3

        positions
          .reject do |pos|
            new_coord = pos.coord
            !XRANGE.include?(new_coord[0]) || !YRANGE.include?(new_coord[1])
          end
          .reject do |pos|
            next false unless pos.linear == 1

            min_turn = pos.coord + pos.dir * 3
            !XRANGE.include?(min_turn[0]) || !YRANGE.include?(min_turn[1])
          end
          .reject do |pos|
            pos.coord == V[XRANGE.max, YRANGE.max] && pos.linear < 4
          end
          .map do |pos|
            new_coord = pos.coord
            Head.new(pos, total + GRID[new_coord], history + [pos])
          end
      end
      .select do |head|
        head => { pos:, total: }
        if best[pos] <= total
          false
        else
          best[pos] = total
          true
        end
      end
      .each do |head|
        head => { total:, pos: { coord: } }
        if coord == V[XRANGE.max, YRANGE.max]
          found = head
          throw :done
        end

        buckets[total] ||= []
        buckets[total] << head
      end
  end
end

puts debug(found.history)
pp found.total
