# frozen_string_literal: true

require "set"

data = $stdin.read

values = {}
monkeys = {}

data.each_line(chomp: true) do |line|
  monkey, value, left, op, right = /(\w{4}): (?:(\d+)|(\w{4}) (.) (\w{4}))/.match(line)&.captures

  next values[monkey] = value.to_i if value

  monkeys[monkey] = [left, right, op.to_sym]
end

values.freeze

def make_queue(root, monkeys, values)
  queue = {}
  satisfied = Set.new
  unsatisfied = [root]

  loop do
    break if unsatisfied.empty?

    monkey = unsatisfied.pop

    next if values[monkey]

    left, right = monkeys[monkey]

    queue[left] ||= []
    queue[left] << monkey
    queue[right] ||= []
    queue[right] << monkey

    satisfied << monkey
    unsatisfied << left unless satisfied.include?(left)
    unsatisfied << right unless satisfied.include?(right)
  end

  queue.each { |_, v| v.freeze }.freeze
end

def find_value(root, queue, monkeys, values)
  queue = queue.dup
  queue.transform_values!(&:dup)

  loop do
    break if queue.empty?

    queue.reject! do |_, v|
      v.reject! do |m|
        left, right, op = monkeys[m]
        next false unless values[left] && values[right]

        values[m] = values[left].send(op, values[right])
        true
      end
      v.empty?
    end
  end

  values[root]
end

# Find which side contains the human
queues = {}
queues[monkeys["root"][0]] = make_queue(monkeys["root"][0], monkeys, values)
queues[monkeys["root"][1]] = make_queue(monkeys["root"][1], monkeys, values)

humn_root = queues.find { |_, v| v.key?("humn") }[0]
monkey_root = queues.find { |_, v| !v.key?("humn") }[0]

target = find_value(monkey_root, queues[monkey_root], monkeys, values.dup)

# Just do a brute force solver
# Might not be valid for all inputs, but mine is arithmetic

def human_value(humn_root, queue, monkeys, values, humn)
  new_values = values.dup
  new_values["humn"] = humn
  find_value(humn_root, queue, monkeys, new_values)
end

min = -target * 10
max = target * 10
min_value = human_value(humn_root, queues[humn_root], monkeys, values, min)
max_value = human_value(humn_root, queues[humn_root], monkeys, values, max)
dir = (max_value - min_value) > 0

humn = 0

loop do
  mid = (min + max) / 2
  new_value = human_value(humn_root, queues[humn_root], monkeys, values, mid)

  break humn = mid if new_value == target

  if target > new_value == dir
    min = mid
    min_value = new_value
  end
  if target < new_value == dir
    max = mid
    max_value = new_value
  end
end

pp humn
