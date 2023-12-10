# frozen_string_literal: true

data = ARGV.first
begin
  data = ARGF.readline.chomp
rescue Errno::ENOENT
  # ignore
end

numbers = data.split(",").map(&:to_i)
last_a = []
last_b = []
numbers.each_with_index do |n, i|
  last_a[n] = i + 1
  last_b[n] = i + 1
end
turn = numbers.length
last = 0

loop do
  turn += 1
  break if turn == 30_000_000

  last_a[last] = b = last_b[last] || turn
  last_b[last] = turn
  last = turn - b
end

pp last
