# frozen_string_literal: true

require "byebug"

instructions = []

DATA.each_line.map(&:chomp).each do |line|
  match = line.match(/^(\w{3}) (\w)(?: (\w|-?\d+))?$/)

  instruction = [match[1], match[2]]
  instruction << ("wxyz".include?(match[3]) ? match[3] : match[3].to_i) if match[3]
  instructions << instruction
end

def run(program, input, z = 0)
  input = input.split("")
  vars = { "w" => 0, "x" => 0, "y" => 0, "z" => z }
  program.each do |instruction, var, target|
    if target
      v = target
      v = vars[target] unless target.is_a?(Integer)
    end

    case instruction
    when "inp"
      vars[var] = input.shift.to_i
    when "mul"
      vars[var] *= v
    when "eql"
      vars[var] = vars[var] == v ? 1 : 0
    when "add"
      vars[var] += v
    when "div"
      vars[var] /= v
    when "mod"
      vars[var] %= v
    end
  end

  vars
end

# The program is divided into 14 sections
# For each section the output only depends on z and w
# z is the z from the previous input
# w is digit 1 - 9
#
# There are two types of sub program.
# formula type 0:  z * 26 + a + i
# formula type 1: z % 26 == b + i ? z / 26 : (z / 26) * 26  + a + i
#
# We can determine the formula by sampling 26 values
#
# If we work forward we can find all possible z outputs up to program 6, keeping
# only those with the highest input
#
# If we work backwards, knowing we want to end at zero, we can again find
# all possible inputs that end in 6 for a given z from program 7 to 13
#
# We can then tie the two together

grouped_instructions = instructions.each_slice(18).to_a

$formulas = []

(0..13).each do |set|
  values = (0..100).map do |z|
    run(grouped_instructions[set], "1", z)["z"]
  end

  $formulas[set] = if values.each_cons(2).all? { |(z1), (z2)| z2 - z1 == 26 }
                     [0, { a: values.first - 1 }]
                   else
                     [1, { a: values.first - 1, b: values.drop(1).index.with_index { |v, i| v < values[i] } }]
                   end
end

# [[0, {:a=>15}],
#  [0, {:a=>8}],
#  [0, {:a=>2}],
#  [1, {:a=>6, :b=>9}],
#  [0, {:a=>13}],
#  [0, {:a=>4}],
#  [0, {:a=>1}],
#  [1, {:a=>9, :b=>5}],
#  [0, {:a=>5}],
#  [1, {:a=>13, :b=>7}],
#  [1, {:a=>9, :b=>12}],
#  [1, {:a=>6, :b=>10}],
#  [1, {:a=>2, :b=>1}],
#  [1, {:a=>2, :b=>11}]]

forward_states = { 0 => "" }

(0..6).each do |set|
  new_states = {}
  ("1".."9").each do |i|
    forward_states.each do |z, input|
      new_z = run(grouped_instructions[set], i, z)["z"]
      new_input = "#{input}#{i}"
      next if new_states.key?(new_z) && new_states[new_z] < new_input

      new_states[new_z] = new_input
    end
  end

  forward_states = new_states
end

def input_for_z_type0(formula, z)
  (1..9).select do |i|
    (z - formula[:a] - i) % 26 == 0
  end.map do |i|
    [i, (z - formula[:a] - i) / 26]
  end
end

def input_for_z_type1(formula, z)
  (1..9).select do |i|
    (z - i - formula[:a]) % 26 == 0
  end.flat_map do |i|
    from = ((z - i - formula[:a]) / 26) * 26
    ((from..from + 25).to_a - [from + formula[:b] + i]).map { |v| [i, v] }
  end + (1..9).map do |i|
    [i, z * 26 + formula[:b] + i]
  end
end

backward_states = { 0 => "" }

(7..13).to_a.reverse.each do |set|
  type, formula = $formulas[set]
  new_states = {}

  backward_states.each do |new_z, input|
    if type == 0
      input_for_z_type0(formula, new_z)
    else
      input_for_z_type1(formula, new_z)
    end.each do |(i, z)|
      new_input = "#{i}#{input}"

      next if new_states.key?(z) && new_states[z] < new_input

      new_states[z] = new_input
    end
  end

  backward_states = new_states
end

best = "9" * 14

backward_states.each do |v, k|
  found = forward_states[v]
  next unless found

  key = "#{found}#{k}"
  best = key if key < best
end

pp best
pp run(instructions, best)

__END__
inp w
mul x 0
add x z
mod x 26
div z 1
add x 10
eql x w
eql x 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 15
mul y x
add z y
inp w
mul x 0
add x z
mod x 26
div z 1
add x 12
eql x w
eql x 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 8
mul y x
add z y
inp w
mul x 0
add x z
mod x 26
div z 1
add x 15
eql x w
eql x 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 2
mul y x
add z y
inp w
mul x 0
add x z
mod x 26
div z 26
add x -9
eql x w
eql x 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 6
mul y x
add z y
inp w
mul x 0
add x z
mod x 26
div z 1
add x 15
eql x w
eql x 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 13
mul y x
add z y
inp w
mul x 0
add x z
mod x 26
div z 1
add x 10
eql x w
eql x 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 4
mul y x
add z y
inp w
mul x 0
add x z
mod x 26
div z 1
add x 14
eql x w
eql x 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 1
mul y x
add z y
inp w
mul x 0
add x z
mod x 26
div z 26
add x -5
eql x w
eql x 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 9
mul y x
add z y
inp w
mul x 0
add x z
mod x 26
div z 1
add x 14
eql x w
eql x 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 5
mul y x
add z y
inp w
mul x 0
add x z
mod x 26
div z 26
add x -7
eql x w
eql x 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 13
mul y x
add z y
inp w
mul x 0
add x z
mod x 26
div z 26
add x -12
eql x w
eql x 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 9
mul y x
add z y
inp w
mul x 0
add x z
mod x 26
div z 26
add x -10
eql x w
eql x 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 6
mul y x
add z y
inp w
mul x 0
add x z
mod x 26
div z 26
add x -1
eql x w
eql x 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 2
mul y x
add z y
inp w
mul x 0
add x z
mod x 26
div z 26
add x -11
eql x w
eql x 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 2
mul y x
add z y
