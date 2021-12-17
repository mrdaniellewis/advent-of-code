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

def fire((vx, vy))
  # pp [vx, vy]
  positions = []
  x = 0
  y = 0
  hit = false

  loop do
    x += vx
    y += vy
    vx = [0, vx - 1].max
    vy -= 1
    positions << [x, y]

    break hit = true if Y_TARGET.include?(y) && X_TARGET.include?(x)

    break if y < Y_TARGET.min || x > X_TARGET.max
  end

  # debug positions
  # puts

  hit
end

hits = []

(Y_TARGET.min..Y_TARGET.min.abs).each do |y|
  (0..X_TARGET.max).each do |x|
    hit = fire([x, y])
    hits << [x, y] if hit
  end
end

pp hits.size

__END__
target area: x=48..70, y=-189..-148
