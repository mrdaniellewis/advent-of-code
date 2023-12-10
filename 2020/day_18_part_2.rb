# frozen_string_literal: true

data = [ARGV.first]
begin
  data = ARGF.each_line.map(&:chomp)
rescue Errno::ENOENT
  # ignore
end

PRECEDENCE = %w[* +]

def parse(expression)
  stack = []
  operators = []
  pos = 0
  loop do
    char = expression[pos]
    break if char.nil?

    case char
    when /\d/
      stack << char.to_i
    when /[*+]/
      while operators.last &&
            operators.last != "(" &&
            PRECEDENCE.index(operators.last) >= PRECEDENCE.index(char)
        stack << operators.pop
      end
      operators << char
    when "("
      operators << "("
    when ")"
      while operators.last != "("
        raise "mismatched params" if operators.empty?

        stack << operators.pop
      end
      raise "mismatched params" if operators.last != "("

      operators.pop
    end

    pos += 1
  end
  until operators.empty?
    raise "mismatched params" if operators.last == "("

    stack << operators.pop
  end
  stack
end

data
  .map { parse(_1) }
  .map do |parsed|
    parsed.each_with_object([]) do |i, stack|
      stack << i if i.is_a? Integer
      stack << stack.pop.send(i.to_sym, stack.pop) if i.is_a? String
    end[0]
  end
  .sum
  .then { pp _1 }
