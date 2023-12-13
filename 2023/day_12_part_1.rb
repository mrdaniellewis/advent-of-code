# frozen_string_literal: true

lines = ARGF.each_line.map(&:chomp).map do |line|
  springs, groups = line.split(" ")

  [springs, groups.split(",").map(&:to_i)]
end

def combinations((springs, groups))
  possibilities = [[1, false]]
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

    possibilities = possibilities.group_by { _1[1..] }.to_a.map do |k, v|
      [v.map { _1[0] }.sum, *k]
    end
    pos += 1
  end

  possibilities.select! { _1[2..] == groups }
  possibilities.map { _1[0] }.sum
end

lines
  .map do |(springs, groups)|
    combinations([springs, groups])
  end
  .sum
  .then { pp _1 }
