# frozen_string_literal: true

class String
  def hash
    codepoints.reduce(0) do |total, code|
      ((total + code) * 17) % 256
    end
  end
end

Instruction = Data.define(:label, :command, :focal_length)

instructions = ARGF.read.chomp.split(",").map do |instruction|
  label, command, focal_length = /(\w+)([=-])(\d?)/.match(instruction).captures
  Instruction.new(label:, command:, focal_length: focal_length.to_i)
end

boxes = []
Lense = Data.define(:label, :focal_length)

instructions.each do |instruction|
  instruction => { label:, command:, focal_length: }
  box_number = label.hash

  case command
  when "-"
    box = boxes[box_number]
    index = box&.find_index { _1.label == label }
    box&.slice!(index, 1) if index
  when "="
    boxes[box_number] ||= []
    box = boxes[box_number]
    index = box.find_index { _1.label == label }
    box[index || box.length] = Lense.new(label:, focal_length:)
  end
end

boxes
  .map.with_index do |box, i|
    next 0 unless box&.any?

    box.map.with_index do |lense, j|
      (1 + i) * (j + 1) * lense.focal_length
    end.sum
  end
  .sum
  .then { pp _1 }
