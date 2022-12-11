# frozen_string_literal: true

require "prime"

data = $stdin.read

$monkeys = []

Monkey = Struct.new("Monkey", :items, :operator, :right, :test, :next_true, :next_false, :inspections)

data.each_line(chomp: true) do |line|
  case line
  when /Monkey/
    $monkeys << Monkey.new
    $monkeys.last.inspections = 0
  when /Starting/
    $monkeys.last.items = line.scan(/\d+/).map(&:to_i)
  when /Operation/
    operator, right = line.match(/= old ([*+]) (\d+|old)/).captures
    $monkeys.last.operator = operator.to_sym
    $monkeys.last.right = right.match?(/\d/) ? right.to_i : :old
  when /Test/
    $monkeys.last.test = line[/\d+/].to_i
  when /If true/
    $monkeys.last.next_true = line[/\d+/].to_i
  when /If false/
    $monkeys.last.next_false = line[/\d+/].to_i
  end
end

$primes = $monkeys.map(&:test).uniq.sort

$monkeys.each do |monkey|
  # For each prime used as a test
  # track the divisibility reminder
  # { 17 => 2 }
  monkey.items = monkey.items.map { |item| $primes.map { [_1, item % _1] }.to_h }
end

10_000.times do
  $monkeys.each do |monkey|
    loop do
      worry = monkey.items.shift
      break if worry.nil?

      monkey.inspections += 1

      worry.each do |k, r|
        if monkey.operator == :+
          r += monkey.right
        elsif monkey.right == :old
          # If we wanted to track the entire number
          # d = ((k * d)**2 + 2 * k * d * r) / k
          r **= 2
        else
          # d *= monkey.right
          r *= monkey.right
        end
        # d += r / k
        r = r % k
        worry[k] = r
      end

      test = worry[monkey.test] == 0

      $monkeys[monkey.next_true].items << worry if test
      $monkeys[monkey.next_false].items << worry unless test
    end
  end
end

pp $monkeys.map(&:inspections).sort.reverse.take(2).inject(:*)
