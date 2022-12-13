# frozen_string_literal: true

require "json"

data = $stdin.read

packets = data.each_line(chomp: true).map do |line|
  JSON.parse(line) if line != ""
end.compact

packets << [[2]]
packets << [[6]]

class Walker
  def initialize(array)
    @array = [array]
  end

  def each(&)
    iterate_array(@array, &)
  end

  def iterate_array(array, &)
    array.each_with_index do |value, index|
      yield [value, index == array.length - 1]
      iterate_array(value, &) if value.is_a?(Enumerable)
    end
  end
end

def sort(left, right)
  left_walker = Walker.new(left).to_enum
  right_walker = Walker.new(right).to_enum

  loop do
    skip_right = left.is_a?(Array) && right.is_a?(Integer)
    skip_left = left.is_a?(Integer) && right.is_a?(Array)

    begin
      left, left_last = skip_left ? [left, true] : left_walker.next
    rescue StopIteration
      break true
    end
    begin
      right, right_last = skip_right ? [right, true] : right_walker.next
    rescue StopIteration
      break false
    end

    break true if left.is_a?(Array) && right.is_a?(Array) && left.empty? && !right.empty?
    break false if left.is_a?(Array) && right.is_a?(Array) && !left.empty? && right.empty?
    break true if left.is_a?(Array) && left.empty? && right.is_a?(Integer)
    break false if right.is_a?(Array) && right.empty? && left.is_a?(Integer)
    break true if left_last && !right_last && left == right
    break false if right_last && !left_last && left == right

    next if !left.is_a?(Integer) || !right.is_a?(Integer)
    break true if left < right
    break false if left > right
  end
end

ordered = packets.sort { |a, b| sort(a, b) ? -1 : 1 }

pp (ordered.find_index([[2]]) + 1) * (ordered.find_index([[6]]) + 1)
