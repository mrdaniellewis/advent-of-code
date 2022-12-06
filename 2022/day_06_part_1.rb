# frozen_string_literal: true

data = $stdin.read

puts(data.chars.index.with_index { |_, index| data.chars[0..index].last(4).uniq.length == 4 } + 1)
