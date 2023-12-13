# frozen_string_literal: true

Line = Struct.new(:springs, :groups)

lines = ARGF.each_line.map(&:chomp).map do |line|
  springs, groups = line.split(" ")

  Line.new(springs:, groups: groups.split(",").map(&:to_i))
end

lines
  .map do |line|
    line => { springs:, groups: }
    broken = groups.sum
    length = springs.length
    max_gap = length - broken - groups.length + 2
    known_broken = springs.tr("?.#", "001").to_i(2)
    known_unbroken = springs.tr("?.#", "010").to_i(2)

    possibilities = (0..max_gap).to_a.map { "0" * _1 }

    groups.each_with_index do |group, i|
      possibilities.map! { _1 + "1" * group }
      next if i == groups.length - 1

      gaps = (1..max_gap).to_a.map { "0" * _1 }
      possibilities = possibilities.flat_map do |p|
        gaps.map { p + _1 }
      end
    end

    possibilities = possibilities.flat_map do |p|
      (0..max_gap).to_a.map { p + "0" * _1 }
    end

    possibilities
      .select { _1.length == length }
      .select { _1.to_i(2) & known_broken == known_broken }
      .select { _1.to_i(2) & known_unbroken == 0 }
      .count
  end
  .sum
  .then { pp _1 }
