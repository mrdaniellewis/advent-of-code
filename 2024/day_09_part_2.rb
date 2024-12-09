# frozen_string_literal: true

ARGF
  .read
  .chomp
  .chars
  .map(&:to_i)
  .each_slice(2)
  .with_index
  .flat_map do |(files, space), i|
    [
      *Array.new(files).fill(i),
      *Array.new(space || 0)
    ]
  end
  # Chunk into [identifier, length]
  .chunk_while { _1 == _2 }
  .map { [_1.first, _1.length] }
  .then do |blocks|
    # Start at end
    i = blocks.length - 1
    loop do
      break if i <= 1

      block = blocks[i]
      # Skip empty space
      next i -= 1 if block[0].nil?

      # Find suitable space
      space_i = blocks.find_index { |(chunk, length)| chunk.nil? && length >= block[1] }
      if space_i && space_i < i
        space = blocks[space_i]
        # Swap file with space
        blocks[space_i] = block
        blocks[i] = [nil, block[1]]

        # Add in left over space, if any
        if space[1] > block[1]
          blocks.insert(space_i + 1, [nil, space[1] - block[1]])
          i += 1
        end

        # Consolidate blank space to the right
        if blocks[i + 1] && blocks[i + 1][0].nil?
          blocks[i][1] += blocks[i + 1][1]
          blocks.delete_at(i + 1)
        end

        # Consolidate blank space to the left
        if blocks[i - 1][0].nil?
          blocks[i][1] += blocks[i - 1][1]
          blocks.delete_at(i - 1)
          i -= 1
        end
      end
      i -= 1
    end

    blocks
  end
  .flat_map { |(chunk, length)| Array.new(length).fill(chunk) }
  .map.with_index { |block, i| block.nil? ? 0 : i * block }
  .sum
  .then { p _1 }
