# frozen_string_literal: true

program = ARGF.read
enabled = true
sum = 0
offset = 0
loop do
  match = program.match(/(?:(?:mul\((\d{1,3}),(\d{1,3})\))|(?:don't\(\))|(?:do\(\)))/, offset)
  break unless match

  offset = match.byteoffset(0)[1]

  if match.match(0) == "do()"
    enabled = true
  elsif match.match(0) == "don't()"
    enabled = false
  elsif enabled
    sum += match.captures.map(&:to_i).inject(:*)
  end
end

p sum
