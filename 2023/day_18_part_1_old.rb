# frozen_string_literal: true

require "matrix"
V = Vector

Instruction = Data.define(:direction, :distance)

DIRECTIONS = {
  "R" => V[1, 0],
  "D" => V[0, 1],
  "L" => V[-1, 0],
  "U" => V[0, -1]
}

instructions = ARGF.each_line.map(&:chomp).map do |line|
  direction, distance = /([RDLU]) (\d+) \(#([a-f0-9]{6})\)/.match(line).captures
  Instruction.new(DIRECTIONS[direction], distance.to_i)
end

plan = Set.new
cursor = V[0, 0]

instructions.each do |instruction|
  instruction => { direction:, distance: }

  distance.times do
    cursor += direction
    plan << cursor
  end
end

def debug(plan)
  xrange = Range.new(*plan.map { _1[0] }.minmax)
  yrange = Range.new(*plan.map { _1[1] }.minmax)

  yrange.map do |y|
    xrange.map do |x|
      plan.include?(V[x, y]) ? "#" : "."
    end.join("")
  end.join("\n") + "\n\n"
end

def find_inside(plan, xrange:, yrange:)
  yrange.each do |y|
    xrange.each do |x|
      pos = V[x, y]
      next if plan.include?(pos)

      cursor = pos
      count = 0
      until cursor[1] < yrange.min
        cursor += V[0, -1]
        count += 1 if plan.include?(cursor)
      end
      return pos if count.odd?
    end
  end
  nil
end

def fill_in(plan)
  xrange = Range.new(*plan.map { _1[0] }.minmax)
  yrange = Range.new(*plan.map { _1[1] }.minmax)
  check = [find_inside(plan, xrange:, yrange:)]
  loop do
    check = check.flat_map do |pos|
      DIRECTIONS.values.map do |dir|
        new_pos = pos + dir
        x, y = new_pos.to_a
        next if plan.include?(new_pos) || !xrange.include?(x) || !yrange.include?(y)

        plan << new_pos
        new_pos
      end.compact
    end
    break if check.empty?
  end
end

fill_in(plan)
puts debug(plan)
pp plan.size
