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

values = [*numbers]

until turn == 30_000_000
  last = last_numbers[last] ? last_numbers[last][-1] - last_numbers[last][-2] : 0
  values << last
  turn += 1
  last_numbers[last] ||= [turn]
  last_numbers[last][0] = last_numbers[last][1] || turn
  last_numbers[last][1] = turn
end

pp last
