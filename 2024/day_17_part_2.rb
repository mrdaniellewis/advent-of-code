# frozen_string_literal: true

_, program = ARGF.read.each_line.map(&:chomp).each_with_object([{}, []]) do |line, (r, p)|
  case line
  when /Register (\w): (\d+)/
    r[Regexp.last_match(1).downcase.to_sym] = Regexp.last_match(2).to_i
  when /Program:/
    p.push(*line.scan(/\d+/).map(&:to_i))
  end
end

program.reverse.map.with_index.reduce(0) do |current, (_result, i)|
  (current * 8...8**(i + 1)).find do |a|
    b = 0
    c = 0
    pointer = 0
    out = []
    loop do
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
    out == program[(-1 - i)..]
  end
end.then { pp _1 }
