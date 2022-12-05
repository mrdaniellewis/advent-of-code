# frozen_string_literal: true

data = $stdin.read

stacks = []
instructions = []

data.each_line do |line|
  if line.start_with?("move")
    quantity, from, to = /(\d+) from (\d+) to (\d+)/.match(line).captures
    instructions << { move: quantity.to_i, from: from.to_i, to: to.to_i }
  elsif line.include?("[")
    line.chars.each_slice(4).with_index do |part, i|
      box = part.join[/\[([A-Z])\]/, 1]
      stacks[i] ||= []
      stacks[i].unshift(box) if box
    end
  end
end

instructions.each do |instruction|
  stacks[instruction[:to] - 1].push(*stacks[instruction[:from] - 1].pop(instruction[:move]))
end

puts stacks.map(&:last).join
