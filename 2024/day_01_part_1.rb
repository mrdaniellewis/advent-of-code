# frozen_string_literal: true

line1, line2 = ARGF.each_line.map(&:chomp).each_with_object([[], []]) do |line, (list1, list2)|
  n1, n2 = line.split(/\s+/)
  list1 << n1.to_i
  list2 << n2.to_i
end

p line1.sort.zip(line2.sort).map { (_1 - _2) }.map(&:abs).sum
