# frozen_string_literal: true

require "matrix"
V = Vector

MIRRORS = ARGF.each_line.map(&:chomp).each_with_object({}).with_index do |(line, m), y|
  line.chars.each_with_index do |char, x|
    next if char == "."

    m[V[x, y]] = char
  end
end

LEFT = Matrix[[0, 1], [-1, 0]]
RIGHT = Matrix[[0, -1], [1, 0]]
IDENTITY = Matrix.identity(2)
SPLITS = {
  "-" => {
    V[1, 0] => [IDENTITY],
    V[-1, 0] => [IDENTITY],
    V[0, 1] => [LEFT, RIGHT],
    V[0, -1] => [LEFT, RIGHT]
  },
  "|" => {
    V[0, 1] => [IDENTITY],
    V[0, -1] => [IDENTITY],
    V[1, 0] => [LEFT, RIGHT],
    V[-1, 0] => [LEFT, RIGHT]
  },
  "\\" => {
    V[0, 1] => [LEFT],
    V[0, -1] => [LEFT],
    V[1, 0] => [RIGHT],
    V[-1, 0] => [RIGHT]
  },
  "/" => {
    V[0, 1] => [RIGHT],
    V[0, -1] => [RIGHT],
    V[1, 0] => [LEFT],
    V[-1, 0] => [LEFT]
  }
}

BEAM_LINES = {
  V[0, 1] => "v",
  V[0, -1] => "^",
  V[1, 0] => ">",
  V[-1, 0] => "<"
}

XRANGE = Range.new(*MIRRORS.keys.map { _1[0] }.minmax)
YRANGE = Range.new(*MIRRORS.keys.map { _1[1] }.minmax)

def debug(energised, paths: true)
  energised_hash = {}
  energised.each do |beam|
    beam => { pos:, dir: }
    energised_hash[pos] = dir
  end

  YRANGE.map do |y|
    XRANGE.map do |x|
      pos = V[x, y]
      if paths
        MIRRORS[pos] || BEAM_LINES[energised_hash[pos]] || "."
      else
        energised_hash[pos] ? "#" : "."
      end
    end.join("")
  end.join("\n") + "\n\n"
end

Beam = Data.define(:pos, :dir)

beam_heads = [Beam.new(V[-1, 0], V[1, 0])]
energised = Set.new

puts debug(energised)
puts debug(energised, paths: false)

loop do
  beam_heads = beam_heads
    .flat_map do |beam|
      beam => { pos:, dir: }
      next_pos = pos + dir
      mirror = MIRRORS[next_pos]
      if mirror
        SPLITS[mirror][dir].map do |rotation|
          Beam.new(next_pos, rotation * dir)
        end
      else
        Beam.new(next_pos, dir)
      end
    end
    .reject do |beam|
      beam => { pos: }
      !XRANGE.include?(pos[0]) ||
        !YRANGE.include?(pos[1]) ||
        energised.include?(beam)
    end
    .each do |beam|
      energised << beam
    end

  break if beam_heads.empty?
end

puts debug(energised)
puts debug(energised, paths: false)

pp energised.map(&:pos).uniq.size
