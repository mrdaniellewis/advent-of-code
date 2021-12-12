# frozen_string_literal: true

caves = Hash.new { [] }

DATA.each_line do |line|
  first, second = line.strip.split("-")
  caves[first] = caves[first].push(second)
  caves[second] = caves[second].push(first)
end

def find_routes(cave, caves, visited = [])
  Enumerator.new do |yielder|
    next yielder << [cave] if cave == "end"

    caves[cave].each do |next_cave|
      next if visited.include?(next_cave) && next_cave.match?(/^[a-z]/)

      find_routes(next_cave, caves, [*visited, cave]).each do |routes|
        yielder << [cave, *routes]
      end
    end
  end
end

puts find_routes("start", caves).to_a.length

__END__
KF-sr
OO-vy
start-FP
FP-end
vy-mi
vy-KF
vy-na
start-sr
FP-lh
sr-FP
na-FP
end-KF
na-mi
lh-KF
end-lh
na-start
wp-KF
mi-KF
vy-sr
vy-lh
sr-mi
