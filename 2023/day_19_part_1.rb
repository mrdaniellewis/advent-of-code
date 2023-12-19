# frozen_string_literal: true

Workflow = Data.define(:name, :instructions)
Instruction = Data.define(:category, :condition, :value, :result)

workflows = {}
parts = []

ARGF.each_line.map(&:chomp).each do |line|
  name, instruction = /^(\w*)\{(.*)\}/.match(line)&.captures
  next unless instruction

  if name == ""
    parts << instruction.split(",").map { _1.split("=") }.to_h { [_1[0], _1[1].to_i] }
  else
    workflow = Workflow.new(
      name,
      instruction.split(",").map do |i|
        category, condition, value, result = /^(?:([amxs])([<>])(\d+):)?(\w+)/.match(i).captures
        Instruction.new(category, condition&.to_sym, value&.to_i, result)
      end
    )
    workflows[workflow.name] = workflow
  end
end

parts
  .select do |part|
    workflow = workflows["in"]
    loop do
      next_workflow = workflow.instructions.find do |instruction|
        instruction => { category:, condition:, value:, result: }
        !category || part[category].send(condition, value)
      end.result
      break true if next_workflow == "A"
      break false if next_workflow == "R"

      workflow = workflows[next_workflow]
    end
  end
  .map { _1.values.sum }
  .sum
  .then { p _1 }
