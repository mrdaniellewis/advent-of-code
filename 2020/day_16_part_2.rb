# frozen_string_literal: true

Field = Struct.new(:name, :r1, :r2, :viable, :position)

fields = []
your_ticket = nil
tickets = []

ARGF.each_line.map(&:chomp).each do |line|
  match = /([\w ]+): (\d+)-(\d+) or (\d+)-(\d+)/.match(line)
  if match
    field, from1, to1, from2, to2 = match.captures
    fields << Field.new(name: field, r1: (from1.to_i..to1.to_i), r2: (from2.to_i..to2.to_i))
  elsif /\d/.match?(line)
    ticket = line.split(",").map(&:to_i)
    if !your_ticket
      your_ticket = ticket
    else
      tickets << ticket
    end
  end
end

tickets.reject! do |ticket|
  ticket.any? do |value|
    fields.none? do |field|
      field => { r1:, r2: }
      r1.include?(value) || r2.include?(value)
    end
  end
end

fields.each do |field|
  field => { r1:, r2: }
  field.viable = (0...fields.length).select do |i|
    tickets.all? do |ticket|
      r1.include?(ticket[i]) || r2.include?(ticket[i])
    end
  end
end

loop do
  field = fields.find { _1.viable.count == 1 }
  field.position = field.viable.first
  fields.each { _1.viable.delete(field.position) }

  break if fields.all?(&:position)
end

fields
  .select { _1.name.start_with?("departure") }
  .map(&:position)
  .map { your_ticket[_1] }
  .reduce(:*)
  .then { puts _1 }
