# frozen_string_literal: true

data = $stdin.read

program = data.split(/\n/).map do |line|
  parts = /^(mask|mem)(?:\[(\d+)\])? = (.*)$/.match(line)

  case parts.captures
  in ["mask", _, mask]
    ["mask", {
      set: mask.tr("X10", "010").to_i(2),
      clear: mask.tr("X10", "011").to_i(2),
      float: mask.tr("X10", "100").to_i(2)
    }]
  in ["mem", register, value]
    ["mem", { register: register.to_i, to: value.to_i }]
  end
end

registers = {}
current_mask = nil

def generate_addresses(value, float)
  values = [value]

  65.times do |i|
    p = 1 << i
    next if float & p == 0

    values.push(*values.map { _1 + p })
  end

  values.uniq
end

program.each do |instruction|
  case instruction
  in ["mask", mask]
    current_mask = mask
  in ["mem", { register:, to: }]
    register |= current_mask[:set]
    register &= current_mask[:clear]

    generate_addresses(register, current_mask[:float]).each do |x|
      registers[x] = to
    end
  end
end

puts registers.values.sum
