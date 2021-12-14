# frozen_string_literal: true

template = nil
rules = []

DATA.each_line.map(&:strip).each do |line|
  next if line == ""
  next template = line.split("") if template.nil?

  pair, insertion = line.split(" -> ")
  rules << [pair.split(""), insertion]
end

# puts template.join("")

10.times do
  new_template = template[0..0]
  template.each_cons(2) do |p|
    _, insertion = rules.find { |(pair)| p == pair }
    if insertion
      new_template.push(insertion, p[1])
    else
      new_template.push(p[1])
    end
  end

  template = new_template
  # puts template.join("")
end

elements = template.each_with_object(Hash.new { 0 }) do |element, totals|
  totals[element] += 1
end

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
