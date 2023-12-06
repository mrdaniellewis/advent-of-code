# frozen_string_literal: true

data = ARGF.read

data.split("\n").map do |line|
  line.gsub(/\D+/, "").strip.to_i
end => time, distance

(0..time)
  .to_a
  .select { (time - _1) * _1 > distance }
  .length
  .then { puts _1 }
