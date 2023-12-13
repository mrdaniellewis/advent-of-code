# frozen_string_literal: true

require "matrix"
V = Vector

patterns = ARGF.each_line.map(&:chomp).each_with_object([[]]) do |line, ag|
  next ag << [] if line == ""

  ag[-1] << line
end.map do |pattern|
  pattern.each_with_object(Set.new).with_index do |(line, h), y|
    line.chars.each_with_index do |char, x|
      h << V[x, y] if char == "#"
    end
  end
end

def debug(pattern, h = {})
  xrange = Range.new(*pattern.map { _1[0] }.minmax)
  Range.new(*pattern.map { _1[1] }.minmax).each do |y|
    xrange.each do |x|
      print(if h[V[x, y]]
              h[V[x, y]]
            elsif pattern.include?(V[x, y])
              "#"
            else
              "."
            end)
    end
    print "\n"
  end
  puts
end

def findx(pattern)
  xmin, xmax = pattern.map { _1[0] }.minmax
  xrange = Range.new(xmin, xmax)
  (0...xmax).find do |xaxis|
    pattern.all? do |v|
      x, y = v.to_a
      mx = 2 * xaxis - x + 1
      !xrange.include?(mx) || pattern.include?(V[mx, y])
    end
  end
end

def findy(pattern)
  ymin, ymax = pattern.map { _1[1] }.minmax
  yrange = Range.new(ymin, ymax)
  (0...ymax).find do |yaxis|
    pattern.all? do |v|
      x, y = v.to_a
      my = 2 * yaxis - y + 1
      !yrange.include?(my) || pattern.include?(V[x, my])
    end
  end
end

patterns
  .map do |pattern|
    [findx(pattern), findy(pattern)]
  end
  .map do |(x, y)|
    x ? x + 1 : (y + 1) * 100
  end
  .sum
  .then { pp _1 }
