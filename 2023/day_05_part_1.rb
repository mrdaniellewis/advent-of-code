# frozen_string_literal: true

require "debug"

data = ARGF.read

seeds = nil
maps = []
current_map = {}

data.split("\n").each do |line|
  case /^(?:(\w+)-to-(\w+) )?(?:(map|seeds): ?)?((?:\d+ ?)+)?$/.match(line).captures
  in [_, _, "seeds", numbers]
    seeds = numbers.split(" ").map(&:to_i)
  in [_, _, "map", nil]
    maps << current_map
  in [nil, nil, nil, nil]
    current_map = {}
  in [nil, nil, nil, numbers]
    destination, source, length = numbers.split(" ").map(&:to_i)
    current_map[Range.new(source, source + length - 1)] = Range.new(destination, destination + length - 1)
  end
end

seeds
  .map do |seed|
    maps.reduce(seed) do |current, type_maps|
      source, destination = type_maps.find { |(start)| start.include?(current) }
      next current unless source

      destination.begin + (current - source.begin)
    end
  end
  .min
  .then { puts _1 }
