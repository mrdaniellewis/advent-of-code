# frozen_string_literal: true

data = $stdin.read

program = data.split(/\n/).map do |line|
  parts = /^(mask|mem)(?:\[(\d+)\])? = (.*)$/.match(line)

  case parts.captures
  in ["mask", _, mask]
    ["mask", { set: mask.tr("X10", "010").to_i(2), clear: mask.tr("X10", "110").to_i(2) }]
  in ["mem", register, value]
    ["mem", { register: register.to_i, to: value.to_i }]
  end
end

registers = []
current_mask = nil

program.each do |instruction|
  case instruction
  in ["mask", mask]
    current_mask = mask
  in ["mem", { register:, to: }]
    to |= current_mask[:set]
    to &= current_mask[:clear]
    registers[register] = to
  end
end

puts registers.compact.sum
