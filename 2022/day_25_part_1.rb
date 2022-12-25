# frozen_string_literal: true

data = $stdin.read

numbers = data.each_line(chomp: true).map(&:itself)

def from_snafu(string)
  string.chars.reverse.each_with_index.reduce(0) do |sum, (part, index)|
    num = { "2" => 2, "1" => 1, "0" => 0, "-" => -1, "=" => -2 }[part]
    sum + num * 5**index
  end
end

def to_snafu(int)
  result = ""
  current = int

  loop do
    carry = 0
    part = current % 5
    case part
    when 3
      result = "=#{result}"
      carry = 1
    when 4
      result = "-#{result}"
      carry = 1
    else
      result = "#{part}#{result}"
    end

    current = current / 5 + carry

    break if current == 0
  end

  result
end

test = [
  [1, "1"],
  [2, "2"],
  [3, "1="],
  [4, "1-"],
  [5, "10"],
  [6, "11"],
  [7, "12"],
  [8, "2="],
  [9, "2-"],
  [10, "20"],
  [15, "1=0"],
  [20, "1-0"],
  [2022, "1=11-2"],
  [12_345, "1-0---0"],
  [314_159_265, "1121-1110-1=0"]
]

test.each do |(dec, snaufu)|
  raise "wrong dec #{dec} #{snaufu} #{from_snafu(snaufu)}" unless dec == from_snafu(snaufu)
  raise "wrong snafu #{dec} #{snaufu} #{to_snafu(dec)}" unless snaufu == to_snafu(dec)
end

puts to_snafu(numbers.map { from_snafu(_1) }.sum)
