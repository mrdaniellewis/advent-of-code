# frozen_string_literal: true

require "matrix"

grid = {}
part_numbers = []
parts = []

Part = Struct.new(:position, :value)
PartNumber = Struct.new(:start, :end, :value)

ARGF.read.split("\n").each_with_index do |line, y|
  number = nil

  line.chars.each_with_index do |c, x|
    pos = Vector[x, y]
    case c
    when /\d/
      part_numbers << number = PartNumber.new(start: pos, value: "") unless number
      number[:value] = (number[:value].to_s + c).to_i
      grid[pos] = number
    when "."
      number = nil if number
    else
      number = nil if number
      parts << part = Part.new(position: pos, value: c)
      grid[pos] = part
    end
  end
end

directions = ([-1, 0, 1].repeated_permutation(2).to_a - [[0, 0]]).map { Vector[_1, _2] }

found = parts.flat_map do |part|
  directions.map do |dir|
    grid[part.position + dir]
  end
end.select { _1.is_a?(PartNumber) }.uniq

pp found.map(&:value).sum
