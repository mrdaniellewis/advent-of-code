# frozen_string_literal: true

towels, patterns = ARGF.read.each_line.map(&:chomp).each_with_object([[], []]) do |line, (t, p)|
  if line.include?(",")
    t.push(*line.split(",").map(&:strip)) if line.include?(",")
  elsif !line.empty?
    p << line
  end
end

regexp = Regexp.new("\\A#{Regexp.union(towels)}+\\z")

patterns.filter { regexp.match?(_1) }.then { pp _1.length }
