# frozen_string_literal: true

data = ARGF.read.chomp.split(",")

class String
  def hash
    codepoints.reduce(0) do |total, code|
      ((total + code) * 17) % 256
    end
  end
end

pp data.map(&:hash).sum
