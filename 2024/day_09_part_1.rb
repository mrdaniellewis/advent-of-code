# frozen_string_literal: true

ARGF
  .read
  .chars
  .map(&:to_i)
  .each_slice(2)
  .with_index
  .flat_map do |(files, space), i|
    [
      *Array.new(files).fill(i),
      *Array.new(space)
    ]
  end
  .then do |blocks|
    spaces = blocks.filter_map.with_index do |block, i|
      block ? false : i
    end

    blocks.reverse.each.with_index do |block, i|
      next unless block

      i = blocks.length - 1 - i
      space = spaces.shift
      break if space >= i

      blocks[space] = block
      blocks[i] = nil
      spaces << i
    end

    blocks
  end
  .map.with_index { |block, i| block.nil? ? 0 : i * block }
  .sum
  .then { p _1 }
