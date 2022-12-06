# frozen_string_literal: true

data = $stdin.read

puts(data.chars.index.with_index { |_, index| data.chars[0..index].last(14).uniq.length == 14 } + 1)
