# frozen_string_literal: true

data = ARGF.read

Race = Struct.new(:time, :distance)

races = []

data.split("\n").tap do |lines|
  times = lines[0].gsub(/\D+/, " ").strip.split(" ").map(&:to_i)
  distances = lines[1].gsub(/\D+/, " ").strip.split(" ").map(&:to_i)

  times.each_with_index do |t, i|
    races << Race.new(time: t, distance: distances[i])
  end
end

races
  .map do |race|
    race => { time:, distance: }

    (0..time)
      .to_a
      .select { (time - _1) * _1 > distance }
      .length
  end
  .reduce(:*)
  .then { puts _1 }
