# frozen_string_literal: true

Workflow = Data.define(:name, :instructions)
Instruction = Data.define(:category, :condition, :value, :result)

class Range
  def overlaps?(other)
    cover?(other.first) || other.cover?(first)
  end

  def bisect(other)
    [
      (Range.new(min, [other.min - 1, max].min) if min < other.min),
      (Range.new([min, other.min].max, [other.max, max].min) if overlaps?(other)),
      (Range.new([min, other.max + 1].max, max) if max > other.max)
    ]
  end
end

workflows = {}

ARGF.each_line.map(&:chomp).each do |line|
  name, instruction = /^(\w*)\{(.*)\}/.match(line)&.captures
  next if name == "" || name.nil?

  workflow = Workflow.new(
    name,
    instruction.split(",").map do |i|
      category, condition, value, result = /^(?:([amxs])([<>])(\d+):)?(\w+)/.match(i).captures
      Instruction.new(category, condition&.to_sym, value&.to_i, result)
    end
  )
  workflows[workflow.name] = workflow
end

flows = []

Head = Data.define(:workflow, :x, :m, :a, :s, :history)

heads = [Head.new(
  workflow: "in",
  x: [1..4000],
  m: [1..4000],
  a: [1..4000],
  s: [1..4000],
  history: ["in"]
)]

loop do
  new_heads = []
  heads.each do |head|
    head => { workflow:, x:, m:, a:, s:, history: }
    workflows[head.workflow].instructions.each do |instruction|
      instruction => { category:, condition:, value:, result: }

      if !condition
        new_heads << Head.new(**head.to_h, workflow: result, history: history + [result])
      else
        range = condition == :> ? Range.new(value + 1, 4000) : Range.new(0, value - 1)

        new_heads << Head.new(
          **head.to_h,
          workflow: result,
          history: history + [result],
          category => head.send(category).map do |r|
            _before, including, _after = r.bisect(range)
            including
          end
        )

        head = Head.new(
          **head.to_h,
          category => head.send(category).map do |r|
            before, _including, after = r.bisect(range)
            condition == :> ? before : after
          end
        )
      end
    end
  end

  new_heads.select! do |head|
    case head.workflow
    when "A"
      flows << head
      false
    when "R"
      false
    else
      true
    end
  end

  heads = new_heads
  break if heads.empty?
end

flows
  .map do |head|
    head => { x:, m:, a:, s: }
    [x, m, a, s].map do |a|
      a.map(&:size).sum
    end.reduce(:*)
  end
  .sum
  .then { puts _1 }
