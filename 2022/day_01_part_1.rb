# frozen_string_literal: true

data = $stdin.read

puts data.split(/\n\n/).map { _1.split(/\n/).map(&:to_i).sum }.max
