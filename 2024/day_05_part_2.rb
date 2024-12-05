# frozen_string_literal: true

rules, updates = ARGF.each_line.map(&:chomp).each_with_object([[], []]) do |line, (r, u)|
  r << line.split("|").map(&:to_i) if line.include?("|")
  u << line.split(",").map(&:to_i) if line.include?(",")
end

before_rules = rules.group_by { _1[0] }.transform_values { |v| v.map { _1[1] } }
after_rules = rules.group_by { _1[1] }.transform_values { |v| v.map { _1[0] } }

updates
  .reject do |pages|
    pages.each_with_index.all? do |n, i|
      before = pages[0...i]
      after = pages[i..]

      (before_rules[n].to_a & before).empty? && (after_rules[n].to_a & after).empty?
    end
  end
  .map do |pages|
    pages.sort do |a, b|
      next -1 if before_rules[a]&.include?(b)
      next 1 if after_rules[a]&.include?(b)

      0
    end
  end
  .map do |pages|
    pages[pages.length / 2]
  end
  .sum
  .then { pp _1 }
