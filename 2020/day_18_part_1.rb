# frozen_string_literal: true

data = [ARGV.first]
begin
  data = ARGF.each_line.map(&:chomp)
rescue Errno::ENOENT
  # ignore
end

def parse(expression)
  stack = []
  pos = 0
  depth = 0
  buffer = nil
  op = nil
  loop do
    char = expression[pos]
    break if char.nil?

    if buffer
      depth += 1 if char == "("
      depth -= 1 if char == ")"

      if depth.zero?
        stack.push(*parse(buffer))
        stack << op if op
        buffer = nil
      else
        buffer += char
      end
    else
      case char
      when /\d/
        stack << char.to_i
        stack << op if op
      when /[*+]/
        op = char
      when "("
        depth += 1
        buffer ||= ""
      end
    end

    pos += 1
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
