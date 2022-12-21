# frozen_string_literal: true

data = $stdin.read

values = {}
monkeys = {}
queue = {}

data.each_line(chomp: true) do |line|
  monkey, value, left, op, right = /(\w{4}): (?:(\d+)|(\w{4}) (.) (\w{4}))/.match(line)&.captures

  next values[monkey] = value.to_i if value

  monkeys[monkey] = [left, right, op.to_sym]
  queue[left] ||= []
  queue[left] << monkey
  queue[right] ||= []
  queue[right] << monkey
end

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

pp values["root"]
