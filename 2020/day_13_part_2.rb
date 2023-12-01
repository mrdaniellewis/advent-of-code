# frozen_string_literal: true

data = $stdin.read

# [number: int, offset: int]
buses = data
  .split(/\n/)[1]
  .strip
  .split(",")
  .map { _1 == "x" ? nil : _1.to_i }
  .map
  .with_index { [_1, _2] }
  .reject { _1[0].nil? }

# Largest bus first
ordered_buses = buses.sort_by { _1[0] }.reverse
time = 0
# We know the answer must be a multiple of the first bus, which is never blank
increment = buses[0][0]

bus_count = 1

catch(:done) do
  loop do
    last = nil
    # Start with just one bus, and find where there is a solution
    # Find the difference between the time of the last solution
    # As the buses are all primes the increment will be a constant with an initial offset
    # When we have an increment add a new bus
    loop do
      # We might be able to exit early
      throw :done if buses.all? { |(bus, i)| (time + i) % bus == 0 }

      if ordered_buses.take(bus_count).all? { |(bus, i)| (time + i) % bus == 0 }
        break increment = time - last unless last.nil?

        last = time
      end

      time += increment
    end

    # Add in a bus
    bus_count += 1
    # Until we've run out of buses
    break if bus_count >= buses.length
  end

  loop do
    throw :done if buses.all? { |(bus, i)| (time + i) % bus == 0 }

    time += increment
  end
end

pp time
