# frozen_string_literal: true

Machine = Struct.new(:a, :b, :prize)

machines = ARGF.read.each_line.map(&:chomp).each_with_object([Machine.new]) do |line, m|
  m << Machine.new if line.empty?

  m.last.a = line.scan(/\d+/).map(&:to_i) if line.start_with?("Button A")
  m.last.b = line.scan(/\d+/).map(&:to_i) if line.start_with?("Button B")
  m.last.prize = line.scan(/\d+/).map(&:to_i) if line.start_with?("Prize")
end

machines
  .map do |machine|
    (0..100).flat_map do |a|
      (0..100).filter_map do |b|
        x = machine.a[0] * a + machine.b[0] * b
        y = machine.a[1] * a + machine.b[1] * b

        next unless x == machine.prize[0] && y == machine.prize[1]

        [a, b]
      end
    end.map { |(a, b)| a * 3 + b }.min
  end
  .compact
  .sum
  .then { pp _1 }
