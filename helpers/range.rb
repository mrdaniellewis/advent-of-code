# frozen_string_literal: true

class Range
  def overlaps?(other)
    cover?(other.first) || other.cover?(first)
  end

  def bisect(other)
    [
      (Range.new(min, [other.min - 1, max].min) if min < other.min),
      (Range.new([min, other.min].max, [other.max, max].min) if overlaps?(other)),
      (Range.new([min, other.max + 1].max, max) if max > other.max)
    ]
  end
end
