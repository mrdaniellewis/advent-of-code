# frozen_string_literal: true

require "matrix"

Machine = Struct.new(:a, :b, :prize)

machines = ARGF.read.each_line.map(&:chomp).each_with_object([Machine.new]) do |line, m|
  m << Machine.new if line.empty?

  m.last.a = line.scan(/\d+/).map(&:to_i) if line.start_with?("Button A")
  m.last.b = line.scan(/\d+/).map(&:to_i) if line.start_with?("Button B")
  m.last.prize = line.scan(/\d+/).map(&:to_i).map { _1 + 10_000_000_000_000 } if line.start_with?("Prize")
end

machines
  .map do |machine|
    # lup.solve is a gussian elemination solver
    Matrix
      .columns([machine.a, machine.b])
      .lup
      .solve(Matrix.column_vector(machine.prize))
  end
  .map(&:column_vectors)
  .map { _1.select { |v| v.all? { |r| r.denominator == 1 } } }
  .reject(&:empty?)
  .map { _1.map { |v| v[0] * 3 + v[1] }.min }
  .sum
  .then { pp _1.to_i }
