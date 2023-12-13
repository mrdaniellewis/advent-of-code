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

def find(pattern)
  xmin, xmax = pattern.map { _1[0] }.minmax
  xrange = Range.new(xmin, xmax)
  ymin, ymax = pattern.map { _1[1] }.minmax
  yrange = Range.new(ymin, ymax)

  oldx = findx(pattern, xrange)
  oldy = findy(pattern, yrange)

  yrange.each do |ys|
    xrange.each do |xs|
      flip = V[xs, ys]
      new_pattern = pattern.dup
      new_pattern.delete?(flip) || (new_pattern << flip)

      xflip = findx(new_pattern, xrange, oldx)
      return [xflip, nil] if xflip

      yflip = findy(new_pattern, yrange, oldy)
      return [nil, yflip] if yflip
    end
  end
end

def findx(pattern, xrange, skip = nil)
  (0...xrange.max).find do |xaxis|
    next false if xaxis == skip

    pattern.all? do |v|
      x, y = v.to_a
      mx = 2 * xaxis - x + 1
      !xrange.include?(mx) || pattern.include?(V[mx, y])
    end
  end
end

def findy(pattern, yrange, skip = nil)
  (0...yrange.max).find do |yaxis|
    next false if yaxis == skip

    pattern.all? do |v|
      x, y = v.to_a
      my = 2 * yaxis - y + 1
      !yrange.include?(my) || pattern.include?(V[x, my])
    end
  end
end

patterns
  .map do |pattern|
    find(pattern)
  end
  .map do |(x, y)|
    x ? x + 1 : (y + 1) * 100
  end
  .sum
  .then { pp _1 }
