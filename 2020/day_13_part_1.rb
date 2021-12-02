# frozen_string_literal: true

earliest = nil
buses = []

DATA.each_line do |line|
  earliest = line.strip.to_i unless earliest
  buses = line.strip.split(",").reject { |n| n == "x" }.map(&:to_i) if earliest
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

__END__
1000053
19,x,x,x,x,x,x,x,x,x,x,x,x,37,x,x,x,x,x,523,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,13,x,x,x,x,23,x,x,x,x,x,29,x,547,x,x,x,x,x,x,x,x,x,41,x,x,x,x,x,x,17
