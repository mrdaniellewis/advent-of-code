# frozen_string_literal: true

grid = []

DATA.each_line do |line|
  grid << line.strip.split("").map(&:to_i)
end

vectors = [-1, 0, 1].repeated_permutation(2).to_a - [[0, 0]]

step = 0

loop do
  step += 1
  energised = []

  puts grid.map(&:join).join("\n")
  puts

  # Step one - increase energy level
  grid.each_with_index do |row, y|
    row.each_with_index do |_, x|
      grid[y][x] += 1
      energised << [x, y] if grid[y][x] > 9
    end
  end

  energised.each do |(x, y)|
    vectors.each do |xd, yd|
      xn = x + xd
      yn = y + yd

      next if xn < 0 || xn == grid[0].length
      next if yn < 0 || yn == grid.length

      grid[yn][xn] += 1

      # Exploits the ability to add to an iterator during iterator
      energised << [xn, yn] if grid[yn][xn] > 9 && !energised.include?([xn, yn])
    end
  end

  # Step three - reset energies to 0
  grid = grid.map do |row|
    row.map do |i|
      i > 9 ? 0 : i
    end
  end

  break if grid.all? { |row| row.all? { |i| i == 0 } }
end

puts grid.map(&:join).join("\n")
puts

puts step

__END__
6111821767
1763611615
3512683131
8582771473
8214813874
2325823217
2222482823
5471356782
3738671287
8675226574
