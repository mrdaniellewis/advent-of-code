# frozen_string_literal: true

reports = ARGF.each_line.map(&:chomp).map do |line|
  line.split(" ").map(&:to_i)
end

safe = reports.select do |initial_report|
  (0..initial_report.length).any? do |i|
    report = initial_report.dup
    report.delete_at(i)
    diff = nil
    last = report.first
    report.drop(1).all? do |num|
      last_diff = diff
      diff = last - num
      last = num
      next false unless (1..3).include?(diff.abs)
      next true unless last_diff
      next false if (diff < 0 && last_diff > 0) || (diff > 0 && last_diff < 0)

      true
    end
  end
end

pp safe.count
