# frozen_string_literal: true

equations = ARGF.each_line.map(&:chomp).map do |line|
  line.split(/[^\d]+/).map(&:to_i)
end

OPERATORS = %i[* +].freeze

equations
  .select do |(total, *parts)|
    OPERATORS.repeated_permutation(parts.length - 1).any? do |ops|
      parts.zip([nil, *ops]).reduce(nil) do |a, (b, op)|
        next b if a.nil?

        a.send(op, b)
      end == total
    end
  end
  .map(&:first)
  .sum
  .then { p _1 }
