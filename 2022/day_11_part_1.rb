# frozen_string_literal: true

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

20.times do
  $monkeys.each do |monkey|
    loop do
      worry = monkey.items.shift
      break if worry.nil?

      monkey.inspections += 1
      worry = worry.public_send(monkey.operator, monkey.right == :old ? worry : monkey.right)
      worry /= 3
      test = (worry % monkey.test).zero?
      $monkeys[monkey.next_true].items << worry if test
      $monkeys[monkey.next_false].items << worry unless test
    end
  end
end

pp $monkeys.map(&:inspections).sort.reverse.take(2).inject(:*)
