# frozen_string_literal: true

data = ARGF.each_line.map(&:chomp)

lines = data.map do |line|
  springs, groups = line.split(" ")

  [springs, groups.split(",").map(&:to_i)]
end

def combinations((springs, groups))
  possibilities = [[0, false]]
  pos = 0
  until pos == springs.length
    case springs[pos]
    when "?"
      possibilities = possibilities.flat_map do |p|
        new = p.dup
        new << 0 unless new[1]
        new[1] = true
        new[-1] += 1

        p[1] = false

        [new, p]
      end
    when "."
      possibilities.each do |p|
        p[1] = false
      end
    when "#"
      possibilities.each do |p|
        p << 0 unless p[1]
        p[1] = true
        p[-1] += 1
      end
    end

    possibilities.select! do |p|
      next true if p.length == 2
      next false if p[1] && p[-1] > (groups[p.length - 3] || 0)
      next false if !p[1] && p[-1] != groups[p.length - 3]

      true
    end

    pp [pos, possibilities.tally, possibilities.count]
    tally = possibilities.tally
    possibilities.uniq!
    possibilities.each do |p|
      p[0] = tally[p]
    end
    pos += 1
  end

  possibilities.select! { _1[2..] == groups }
  pp possibilities.count
  possibilities.count
end

lines
  .slice(1, 1)
  .map do |(springs, groups)|
    pp combinations([([springs] * 5).join("?"), groups * 5])
  end
  .sum
  .then { pp _1 }
