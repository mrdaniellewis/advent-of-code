# frozen_string_literal: true

require "set"

data = $stdin.read

Valve = Struct.new(:name, :rate, :tunnels)

VALVES = data.each_line(chomp: true).map do |line|
  name, rate, tunnels = line.match(/Valve (\w{2}) has flow rate=(\d+); tunnels? leads? to valves? (.*)/).captures

  [name, Valve.new(name, rate.to_i, tunnels.split(", "))]
end.to_h

VALVE_BY_SIZE = Set.new(VALVES
  .filter { |_, v| v.rate > 0 }
  .map { |(k, v)| [k, v.rate] }
  .sort { _2[1] - _1[1] }
  .map { _1[0] })

ALL_OPENABLE_VALUES = Set.new(VALVES.filter { |_, v| v.rate > 0 }.keys)

def no_remaining_valves?(open)
  ALL_OPENABLE_VALUES == open
end

def largest_remaining_valve?(open, name)
  (VALVE_BY_SIZE - open).first == name
end

def visit(journey, open, pressure, length, since_last_valve, narrative)
  valve = VALVES[journey.last]

  next_journeys = []

  # Do nothing journey
  return [[journey, open, pressure, length + 1, since_last_valve, narrative]] if no_remaining_valves?(open)

  if !open.include?(valve.name) && valve.rate > 0
    next_journeys << [
      journey,
      open + [valve.name],
      pressure + (valve.rate * (30 - length - 1)),
      length + 1,
      [valve.name],
      narrative + ["open #{valve.name}"]
    ]
  end

  # Failure to open the largest value if we are at it cannot help
  return next_journeys if largest_remaining_valve?(open, valve.name)

  next_tunnels = valve
    .tunnels
    .filter { !since_last_valve.include?(_1) } # Eliminate going in circles
    .map do |n|
      [journey + [n], open, pressure, length + 1, since_last_valve + [n], narrative + ["visit #{n}"]]
    end

  next_journeys.push(*next_tunnels)

  next_journeys
end

journeys = Enumerator.new do |yielder|
  queue = [[["AA"], Set.new, 0, 0, [], []]]
  loop do
    new_queue = []
    loop do
      visit(*queue.shift).each do |item|
        if item[3] == 30
          yielder << item
        else
          new_queue.push(item)
        end
      end

      break if queue.empty?
    end

    break if new_queue.empty?

    # Take 500 is arbitrary
    queue = new_queue.sort { _2[2] - _1[2] }.take(500)
  end
end

pp journeys.to_a.map { _1[2] }.max
