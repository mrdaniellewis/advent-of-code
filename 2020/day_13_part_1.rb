# frozen_string_literal: true

data = $stdin.read

earliest = nil
buses = []

data.each_line do |line|
  earliest ||= line.strip.to_i
  buses = line.strip.split(",").reject { _1 == "x" }.map(&:to_i) if earliest
end

times = buses.map do |number|
  arrival = 0
  loop do
    arrival += number
    break if arrival >= earliest
  end
  arrival
end

time, index = times.each_with_index.min
puts (time - earliest) * buses[index]
