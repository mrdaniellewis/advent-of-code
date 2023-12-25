# frozen_string_literal: true

require "matrix"
V = Vector
X = 0
Y = 1

MIN = ARGV.shift.to_i
MAX = ARGV.shift.to_i
RANGE = Range.new(MIN, MAX)

class Line
  attr_reader :base, :slope

  def initialize(base, slope)
    @base = base
    @slope = slope
  end

  # https://stackoverflow.com/a/73079842
  def self.intersections(line1, line2)
    m = Matrix.columns([line1.slope, -line2.slope])
    return nil if m.determinant.zero?

    m.inverse * (line2.base - line1.base)
  end

  def intersection(line)
    i = self.class.intersections(self, line)
    return nil unless i

    @base + @slope * i[0]
  end
end

class Hail
  attr_reader :name, :start, :velocity

  @@namer = ("A"..).to_enum

  def initialize(start, velocity)
    @name = @@namer.next
    @start = start
    @velocity = velocity
  end

  def to_line
    Line.new(start, velocity)
  end

  def intersection(h)
    to_line.intersection(h.to_line)
  end

  def intersections(h)
    Line.intersections(to_line, h.to_line)
  end
end

hails = ARGF.each_line.map(&:chomp).map do |line|
  pos, velocity = line.split(" @ ")
  Hail.new(
    V[*pos.split(", ").map(&:to_i).take(2)],
    V[*velocity.split(", ").map(&:to_i).take(2)]
  )
end

hails
  .combination(2)
  .to_a
  .select do |(h1, h2)|
    intersections = h1.intersections(h2)
    next false if intersections.nil? || intersections.any? { _1 < 0 }

    intersection = h1.intersection(h2)
    intersection.to_a.all? { RANGE.include?(_1) }
  end
  .size
  .then { pp _1 }
