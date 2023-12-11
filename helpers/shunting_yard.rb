# frozen_string_literal: true

class ShuntingYard
  PRECEDENCE = {
    "+" => 1,
    "-" => 1,
    "*" => 2,
    "/" => 2,
    "**" => 3
  }

  def self.parse(tokens)
    stack = []
    operators = []
    loop do
      token = tokens.next
      break if token.nil?

      case token
      when Numeric
        stack << token
      when PRECEDENCE[token]
        while operators.last &&
              operators.last != "(" &&
              PRECEDENCE[operators.last] >= PRECEDENCE[token]
          stack << operators.pop
        end
        operators << token
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
    end
    until operators.empty?
      raise "mismatched params" if operators.last == "("

      stack << operators.pop
    end
    stack
  end

  def resolve(parsed)
    parsed.each_with_object([]) do |i, stack|
      stack << i if i.is_a? Numeric
      stack << stack.pop.send(i.to_sym, stack.pop) if i.is_a? String
    end[0]
  end
end
