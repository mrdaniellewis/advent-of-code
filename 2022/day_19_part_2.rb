# frozen_string_literal: true

require "set"

data = $stdin.read

blueprints = data.each_line(chomp: true).map do |line|
  number, ore_ore, clay_ore, ob_ore, ob_clay, geo_ore, geo_ob = line.scan(/\d+/).map(&:to_i)

  [
    number,
    {
      ore: { ore: ore_ore },
      clay: { ore: clay_ore },
      obsidian: { ore: ob_ore, clay: ob_clay },
      geode: { ore: geo_ore, obsidian: geo_ob }
    }
  ]
end.to_h

ORES = %i[ore clay obsidian geode]

def build(robot, blueprint, resources, robots)
  robots[robot] += 1
  blueprint[robot].each { |r, v| resources[r] -= v }
end

def mine(resources, robots, skip_mine)
  resources.each_key do |v|
    if skip_mine.include?(v)
      resources[v] = 0
    else
      resources[v] += robots[v]
    end
  end
end

def option_mine(resources, robots, skip_mine)
  resources = resources.dup
  robots = robots.dup
  mine(resources, robots, skip_mine)
  [resources.freeze, robots.freeze]
end

def option_build_and_mine(resources, robots, blueprint, make_robot, skip_mine)
  resources = resources.dup
  robots = robots.dup
  built_robots = { geode: 0, obsidian: 0, clay: 0, ore: 0 }

  build(make_robot, blueprint, resources, built_robots)
  mine(resources, robots, skip_mine)
  built_robots.each { |r, v| robots[r] += v }

  [resources.freeze, robots.freeze]
end

def can_build?(resources, blueprint, make_robot)
  blueprint[make_robot].all? { |r, v| resources[r] >= v }
end

def simulate(blueprint, resources, robots, skip_build, skip_mine)
  options = []

  ORES.each do |ore|
    next if skip_build.include?(ore)
    next unless can_build?(resources, blueprint, ore)

    # Always build an geode robot
    return [option_build_and_mine(resources, robots, blueprint, ore, skip_mine)] if ore == :geode

    options << option_build_and_mine(resources, robots, blueprint, ore, skip_mine)
  end

  # No build option
  options << option_mine(resources, robots, skip_mine)

  options
end

MAX_MINUTES = 32

def optimise_blueprint(blueprint)
  resources = {
    ore: 0,
    clay: 0,
    obsidian: 0,
    geode: 0
  }.freeze

  robots = {
    ore: 1,
    clay: 0,
    obsidian: 0,
    geode: 0
  }.freeze

  Enumerator.new do |yielder|
    queue = [[resources, robots]]
    skip_build = Set.new
    skip_mine = Set.new

    minutes = 0
    loop do
      minutes += 1
      skip_build << :ore if minutes == MAX_MINUTES
      skip_build << :geode if minutes == MAX_MINUTES
      skip_build << :obsidian if minutes == MAX_MINUTES - 1
      skip_build << :clay if minutes == MAX_MINUTES - 2

      skip_mine << :ore if minutes == MAX_MINUTES
      skip_mine << :obsidian if minutes == MAX_MINUTES - 1
      skip_mine << :clay if minutes == MAX_MINUTES - 2

      new_queue = []
      loop do
        scenario = queue.shift
        if minutes == MAX_MINUTES + 1
          yielder << scenario
        else
          new_queue.push(*simulate(blueprint, *scenario, skip_build, skip_mine))
        end

        break if queue.empty?
      end

      break if new_queue.empty?

      puts "#{minutes} - #{new_queue.length}"

      max = new_queue.max_by { _1[1][:geode] }[1][:geode]
      if max > 0
        queue = new_queue.reject { _1[1][:geode] < max - 1 }.uniq
      else
        max = new_queue.max_by { _1[1][:obsidian] }[1][:obsidian]
        queue = new_queue.reject { _1[1][:obsidian] < max - 1 }.uniq
      end
    end
  end
end

score = blueprints.take(3).map do |k, v|
  puts
  puts "##{k}"
  optimise_blueprint(v).to_a.map { _1[0][:geode] }.max
end.reduce(:*)

puts
puts score
