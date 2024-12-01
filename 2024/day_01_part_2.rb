# frozen_string_literal: true

line1, line2 = ARGF.each_line.map(&:chomp).each_with_object([[], []]) do |line, (list1, list2)|
  n1, n2 = line.split(/\s+/)
  list1 << n1.to_i
  list2 << n2.to_i
end

counts = line2.tally
p line1.map { _1 * counts[_1].to_i }.sum
