# frozen_string_literal: true

p ARGF.read.scan(/mul\((\d{1,3}),(\d{1,3})\)/).map { _1.map(&:to_i).inject(:*) }.sum
