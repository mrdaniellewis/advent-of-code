# frozen_string_literal: true

module Enumerable
  # Find the start and length of a cycle using floyd
  def find_cycle_floyd
    hare_enum = to_enum
    tortoise_enum = to_enum
    hare = nil
    return nil unless loop do
      tortoise = tortoise_enum.next
      hare_enum.next
      hare = hare_enum.next
      break true if hare == tortoise
    end

    i = 0
    tortoise_enum = to_enum
    tortoise = nil
    until tortoise == hare
      hare = hare_enum.next
      tortoise = tortoise_enum.next
      i += 1
    end

    len = 1
    hare = tortoise_enum.next
    until tortoise == hare
      hare = tortoise_enum.next
      len += 1
    end

    [i - 1, len]
  rescue StopIteration
    nil
  end
end
