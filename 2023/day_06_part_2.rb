# frozen_string_literal: true

data = ARGF.read

data.split("\n").map do |line|
  line.gsub(/\D+/, "").strip.to_i
end => time, distance

lower = (0..time).bsearch do |v|
  (time - v) * v > distance
end

upper = (lower..time).bsearch do |v|
  (time - v) * v <= distance
end

pp upper - lower
