# frozen_string_literal: true

require "debug"

class Range
  def overlaps?(other)
    cover?(other.first) || other.cover?(first)
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
      # Entirely before
      if seed.end < source.begin
        new_seeds << seed
        seed = nil
        break
      end

      # Partly before
      new_seeds << Range.new(seed.begin, source.begin - 1) if seed.begin < source.begin && source.overlaps?(seed)

      if source.overlaps?(seed)
        new_seeds << Range.new(
          destination.begin + ([seed.begin, source.begin].max - source.begin),
          destination.begin + ([seed.end, source.end].min - source.begin)
        )
      end

      if source.include?(seed.end)
        # Nothing after
        seed = nil
        break
      elsif seed.end > source.end && source.overlaps?(seed)
        # partly after
        seed = Range.new(source.end + 1, seed.end)
      end
    end

    new_seeds << seed if seed
    new_seeds
  end

  break if mappings.empty?
end

pp seeds.map(&:begin).min
