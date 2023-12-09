# frozen_string_literal: true

sequences = ARGF.read.each_line.map(&:chomp).map { _1.split(" ").map(&:to_i) }

trees = sequences.map do |sequence|
  Enumerator.new do |y|
    y << sequence
    until sequence.all?(&:zero?)
      sequence = sequence.each_cons(2).map { _2 - _1 }
      y << sequence
    end
  end.to_a.reverse
end

trees
  .map do |tree|
    tree.reduce(0) do |total, sequence|
      total + sequence.last
    end
  end
  .sum
  .then { puts _1 }
