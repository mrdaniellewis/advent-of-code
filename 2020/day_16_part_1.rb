# frozen_string_literal: true

fields = {}
your_ticket = nil
tickets = []

ARGF.each_line.map(&:chomp).each do |line|
  match = /(\w+): (\d+)-(\d+) or (\d+)-(\d+)/.match(line)
  if match
    field, from1, to1, from2, to2 = match.captures
    fields[field] = [(from1.to_i..to1.to_i), (from2.to_i..to2.to_i)]
  elsif /\d/.match?(line)
    ticket = line.split(",").map(&:to_i)
    if !your_ticket
      your_ticket = ticket
    else
      tickets << ticket
    end
  end
end

tickets
  .flat_map do |ticket|
    ticket.select do |value|
      fields.none? do |_, (r1, r2)|
        r1.include?(value) || r2.include?(value)
      end
    end
  end
  .sum
  .then { puts _1 }
