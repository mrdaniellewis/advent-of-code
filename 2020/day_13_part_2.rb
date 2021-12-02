# frozen_string_literal: true

require "pp"

buses = nil

DATA.each_line do |line|
  buses ||= line.strip.split(",").map { |n| n == "x" ? nil : n.to_i }
end

interval = buses[0]
buses_with_index = buses.each_with_index.to_a.reject { |(value, index)| value.nil? }

results = {}
buses_with_index.each do |(bus, index)|
  comp = {}

  buses_with_index.each do |(b, i)|
    count = 0
    offset = nil
    diff = index - i

    loop do
      match = count + diff >= 0 && (count + diff) % bus == 0

      break if offset && match
      offset ||= count if match
      count += b
    end

    comp[b] = [offset + diff, count - offset]
  end

  results[bus] = comp
end


pp results

# puts matches.reduce(:*)


# count = 0
#
# loop do
#   count += max
#
#   break if buses_with_index.all? do |(bus, i)|
#     (count - index + i) % bus == 0
#   end
# end

# puts count - index

# times = buses.map do |number|
#   arrival = 0
#   loop do
#     arrival += number
#     break if arrival >= earliest
#   end
#   arrival
# end
#
# time, index = times.each_with_index.min
# puts (time - earliest) * buses[index]


#    0         1         2         3         4         5         6         7         8         9         10        12        13        14        15        16
#    0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
# 3  x  x  x  x  x  x  x  x  x  x  x  x  x  x  x  x  x  x  x  x  x  x  x  x  x  x  x  x  x  x  x  x  x  x  x  x  x  x  x  x  x  x  x  x  x  x  x  x  x  x  x  x  x  x
# 7  x      x      x      x      x      x      x      x      x      x      x      x      x      x      x      x      x      x      x      x      x      x      x
# 11 x          x          x          x          x          x          x          x          x          x          x          x          x          x          x
# 2  x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x
#
# T = 7a       7a = T
# T + 1 = 13b  77 + 91b = T
# T + 4 = 59c  350 + 413b = T
# T + 6 = 31d  56 + 217d = T
# T + 7 = 19e  126 + 133e = T
#
# 7a = 7a
# 78 + 91b = 13b
# 354 + 413b = 59c
# 72 + 217d  = 31d
# 133 + 133e = 19e

__END__
7,13,x,x,59,x,31,19
