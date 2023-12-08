# frozen_string_literal: true

require "debug"

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

data = ARGF.read

seeds = nil
mappings = []
current_map = []

data.split("\n").each do |line|
  case /^(?:(\w+)-to-(\w+) )?(?:(map|seeds): ?)?((?:\d+ ?)+)?$/.match(line).captures
  in [_, _, "seeds", numbers]
    seeds = numbers.split(" ").map(&:to_i).each_slice(2).map { Range.new(_1, _1 + _2 - 1) }
  in [_, _, "map", nil]
    mappings << current_map
  in [nil, nil, nil, nil]
    current_map = []
  in [nil, nil, nil, numbers]
    destination, source, length = numbers.split(" ").map(&:to_i)
    current_map << [Range.new(source, source + length - 1), Range.new(destination, destination + length - 1)]
  end
end

mappings.each { _1.sort_by! { |(source)| source.begin } }

loop do
  mapping = mappings.shift

  seeds = seeds.flat_map do |seed|
    new_seeds = []
    mapping.each do |(source, destination)|
      before, inside, after = seed.bisect(source)

      new_seeds << before if before

      if inside
        diff = destination.first - source.first
        new_seeds << Range.new(inside.first + diff, inside.last + diff)
      end

      if after
        seed = after
      else
        seed = nil
        break
      end
    end

    new_seeds << seed if seed
    new_seeds
  end

  break if mappings.empty?
end

pp seeds.map(&:begin).min
