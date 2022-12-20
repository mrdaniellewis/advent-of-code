# frozen_string_literal: true

data = $stdin.read

code = data.each_line(chomp: true).map(&:to_i)
LENGTH = code.length
code = code.map.with_index do |v, i|
  p = i - 1
  p = LENGTH - 1 if p == -1
  n = i + 1
  n = 0 if n == LENGTH
  [p, v * 811_589_153, n]
end

def rebuild(code)
  cursor = 0
  Enumerator.new do |y|
    loop do
      _, v, n = code[cursor]
      y << v
      cursor = n

      break if cursor == 0
    end
  end
end

10.times do
  code.each_with_index do |(p, v, n), i|
    next if v == 0

    # Remove self and join current positions
    pp, _, pn = code[p]
    np, _, nn = code[n]
    raise if pn != np

    code[p][0] = pp
    code[p][2] = n
    code[n][0] = p
    code[n][2] = nn

    # Find new position
    # It is a loop so we can mod the distance

    newp = p
    newn = n
    if v > 0
      # Track positions forward
      (v % (LENGTH - 1)).times do
        newp = newn
        _, _, newn = code[newn]
      end
    else
      # Track positions backwards
      (v.abs % (LENGTH - 1)).times do
        newn = newp
        newp, = code[newp]
      end
    end

    # insert self into new position
    _, _, pn = code[newp]
    np, = code[newn]
    raise if newp != np
    raise if newn != pn

    code[newp][2] = i
    code[newn][0] = i
    code[i][0] = newp
    code[i][2] = newn
  end
end

code = rebuild(code).to_a

pp([1000, 2000, 3000].map do |p|
  code[(p + code.index(0)) % LENGTH]
end.sum)
