# frozen_string_literal: true

pairs = Hash.new { 0 }
last = nil
rules = []

DATA.each_line.map(&:strip).each do |line|
  next if line == ""

  if pairs.empty?
    line.split("").each_cons(2) { |p| pairs[p.join] = 1 }
    last = line[-1]
    next
  end

  pair, insertion = line.split(" -> ")
  rules << [pair, ["#{pair[0]}#{insertion}", "#{insertion}#{pair[1]}"]]
end

40.times do
  new_pairs = pairs.dup
  # inserting an item transforms one pair into two pairs
  # so we only need to keep track of the number of pairs
  pairs.each do |pair, count|
    _, (new1, new2) = rules.find { |(p)| p == pair }
    new_pairs[pair] -= count
    new_pairs[new1] += count
    new_pairs[new2] += count
  end

  pairs = new_pairs
end

# Just count the first item in each pair
elements = pairs.each_with_object(Hash.new { 0 }) do |(pair, total), totals|
  totals[pair[0]] += total
end
# And add the last element in the chain
elements[last] += 1

puts elements.max_by { |_, v| v }[1] - elements.min_by { |_, v| v }[1]

__END__
SHHNCOPHONHFBVNKCFFC

HH -> K
PS -> P
BV -> H
HB -> H
CK -> F
FN -> B
PV -> S
KK -> F
OF -> C
SF -> B
KB -> S
HO -> O
NH -> N
ON -> V
VF -> K
VP -> K
PH -> K
FF -> V
OV -> N
BO -> K
PO -> S
CH -> N
FO -> V
FB -> H
FV -> N
FK -> S
VC -> V
CP -> K
CO -> K
SV -> N
PP -> B
BS -> P
VS -> C
HV -> H
NN -> F
NK -> C
PC -> V
HS -> S
FS -> S
OB -> S
VV -> N
VO -> P
KV -> F
SK -> O
BC -> P
BP -> F
NS -> P
SN -> S
NC -> N
FC -> V
CN -> S
OK -> B
SC -> N
HN -> B
HP -> B
KP -> B
CB -> K
KF -> C
OS -> B
BH -> O
PN -> K
VN -> O
KH -> F
BF -> H
HF -> K
HC -> P
NP -> H
KO -> K
CF -> H
BK -> O
OH -> P
SO -> F
BB -> F
VB -> K
SP -> O
SH -> O
PK -> O
HK -> P
CC -> V
NB -> O
NV -> F
OO -> F
VK -> V
FH -> H
SS -> C
NO -> P
CS -> H
BN -> V
FP -> N
OP -> N
PB -> P
OC -> O
SB -> V
VH -> O
KS -> B
PF -> N
KN -> H
NF -> N
CV -> K
KC -> B
