# frozen_string_literal: true

caves = Hash.new { [] }

DATA.each_line do |line|
  first, second = line.strip.split("-")
  caves[first] = caves[first].push(second)
  caves[second] = caves[second].push(first)
end

def find_routes(cave, caves, visited = Hash.new { 0 })
  Enumerator.new do |yielder|
    next yielder << [cave] if cave == "end"

    caves[cave].each do |next_cave|
      new_visited = visited

      if next_cave.match?(/^[a-z]/)
        next if next_cave == "start"
        next if visited[next_cave] == 2
        next if visited[next_cave] == 1 && visited.find { |_, v| v == 2 }

        new_visited = visited.dup
        new_visited[next_cave] = new_visited[next_cave] + 1
      end

      find_routes(next_cave, caves, new_visited).each do |routes|
        yielder << [cave, *routes]
      end
    end
  end
end

puts find_routes("start", caves).reduce(0) { |count| count + 1 }

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
