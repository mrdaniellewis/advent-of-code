# frozen_string_literal: true

require "byebug"

match = DATA.readline.strip.match(/x=(?<x1>\d+)\.{2}(?<x2>\d+), y=(?<y1>-?\d+)\.{2}(?<y2>-?\d+)/)

Y_TARGET = (match.named_captures["y1"].to_i..match.named_captures["y2"].to_i)
X_TARGET = (match.named_captures["x1"].to_i..match.named_captures["x2"].to_i)

def debug(positions = [])
  ycoords = ([0] + positions.map { |(_, y)| y } + Y_TARGET.to_a)
  xcoords = ([0] + positions.map { |(x)| x } + X_TARGET.to_a)

  puts((ycoords.min..ycoords.max).to_a.reverse.map do |y|
    (xcoords.min..xcoords.max).to_a.map do |x|
      next "S" if [0, 0] == [x, y]
      next "#" if positions.include?([x, y])

      Y_TARGET.include?(y) && X_TARGET.include?(x) ? "T" : "."
    end.join
  end.join("\n"))
end

def fire(vy)
  y = 0
  hit = false
  positions = []

  loop do
    y += vy
    vy -= 1
    positions << y

    break hit = true if Y_TARGET.include?(y)
    break hit = false if Y_TARGET.min > y
  end

  {
    hit: hit,
    height: hit ? positions.max : nil
  }
end

best_height = 0
best = nil

(0..).each do |y|
  results = fire(y)

  if results[:hit] && (best.nil? || results[:height] > best_height)
    best_height = results[:height]
    best = y
  end

  # This will always miss
  break if Y_TARGET.min.abs < y
end

pp best_height

__END__
target area: x=48..70, y=-189..-148
