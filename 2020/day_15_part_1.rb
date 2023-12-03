# frozen_string_literal: true

data = ARGV.first
begin
  data = ARGF.readline.chomp
rescue Errno::ENOENT
  # ignore
end

numbers = data.split(",").map(&:to_i)
last_numbers = numbers.each_with_index.to_h { [_1, [_2 + 1, _2 + 1]] }
turn = numbers.length
last = numbers.last
until turn == 2020
  first, second = last_numbers[last]
  last = second - first
  turn += 1
  last_numbers[last] = if last_numbers.include?(last)
                         [last_numbers[last][1], turn]
                       else
                         [turn, turn]
                       end
end

pp last
