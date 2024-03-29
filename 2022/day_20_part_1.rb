# frozen_string_literal: true

data = $stdin.read

code = data.each_line(chomp: true).map(&:to_i)
LENGTH = code.length
code = code.map.with_index do |v, i|
  p = i - 1
  p = LENGTH - 1 if p == -1
  n = i + 1
  n = 0 if n == LENGTH
  [p, v, n]
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

code.each_with_index do |(p, v, n), i|
  next if v == 0

  # remove self and join current positions
  pp, pv, pn = code[p]
  np, nv, nn = code[n]
  raise if pn != np

  code[p] = [pp, pv, n]
  code[n] = [p, nv, nn]

  # Find new position
  newp = p
  newn = n
  if v > 0
    # Track positions forward
    v.times do
      newp = newn
      _, _, newn = code[newn]
    end
  else
    # Track positions backwards
    v.abs.times do
      newn = newp
      newp, = code[newp]
    end
  end

  # insert self into new position
  pp, pv, pn = code[newp]
  np, nv, nn = code[newn]
  raise if newp != np
  raise if newn != pn

  code[newp] = [pp, pv, i]
  code[newn] = [i, nv, nn]
  code[i] = [newp, v, newn]
end

code = rebuild(code).to_a

pp([1000, 2000, 3000].map do |p|
  code[(p + code.index(0)) % LENGTH]
end.sum)
