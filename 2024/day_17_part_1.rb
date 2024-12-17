# frozen_string_literal: true

registers, program = ARGF.read.each_line.map(&:chomp).each_with_object([{}, []]) do |line, (r, p)|
  case line
  when /Register (\w): (\d+)/
    r[Regexp.last_match(1).downcase.to_sym] = Regexp.last_match(2).to_i
  when /Program:/
    p.push(*line.scan(/\d+/).map(&:to_i))
  end
end

registers => { a:, b:, c: }
pointer = 0
out = []
loop do
  # pp({ pointer:, a:, b:, c: })

  break if pointer >= program.length

  opcode = program[pointer]
  operand = program[pointer + 1]
  combo = case operand
          when (0..3)
            operand
          when 4
            a
          when 5
            b
          when 6
            c
          end

  # pp({ opcode:, operand:, combo: })
  case opcode
  when 0
    a /= 2**combo
  when 1
    b ^= operand
  when 2
    b = combo % 8
  when 3
    next pointer = operand unless a == 0
  when 4
    b ^= c
  when 5
    out << combo % 8
  when 6
    b = a / 2**combo
  when 7
    c = a / 2**combo
  end

  pointer += 2
end

puts out.join(",")
