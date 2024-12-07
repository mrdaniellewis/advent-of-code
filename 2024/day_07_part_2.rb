# frozen_string_literal: true

equations = ARGF.each_line.map(&:chomp).map do |line|
  line.split(/[^\d]+/).map(&:to_i)
end

OPERATORS = %i[* + join_digits].freeze

class Integer
  def join_digits(i)
    (to_s + i.to_s).to_i
  end
end

equations
  .select do |(total, *parts)|
    OPERATORS.repeated_permutation(parts.length - 1).any? do |ops|
      parts.zip([nil, *ops]).reduce(nil) do |a, (b, op)|
        next b if a.nil?

        v = a.send(op, b)
        break 0 if v > total

        v
      end == total
    end
  end
  .map(&:first)
  .sum
  .then { p _1 }
