# frozen_string_literal: true

numbers = []

DATA.each_line do |line|
  numbers << line.strip.to_i
end

sorted_numbers = [0, *numbers].sort

sequences = [0, 0]
current = 0

sorted_numbers.each_with_index.map do |number, index|
  next if index.zero?

  current += 1 if number - sorted_numbers[index - 1] == 1

  next unless number - sorted_numbers[index - 1] == 3

  sequences[current] ||= 0
  sequences[current] += 1
  current = 0
end

sequences[current] ||= 0
sequences[current] += 1

multipliers = [1, 1, 2, 4, 7]

puts(sequences.zip(multipliers).map { |(a, b)| b**a }.reduce(1, :*))

__END__
165
78
151
15
138
97
152
64
4
111
7
90
91
156
73
113
93
135
100
70
119
54
80
170
139
33
123
92
86
57
39
173
22
106
166
142
53
96
158
63
51
81
46
36
126
59
98
2
16
141
120
35
140
99
121
122
58
1
60
47
10
87
103
42
132
17
75
12
29
112
3
145
131
18
153
74
161
174
68
34
21
24
85
164
52
69
65
45
109
148
11
23
129
84
167
27
28
116
110
79
48
32
157
130
