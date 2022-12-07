# frozen_string_literal: true

data = $stdin.read

directories = { name: "/", type: "dir", children: [] }

data.each_line(chomp: true).with_object([[directories]]) do |line, stack|
  if line.match?(/^\d+ \w/)
    size, name = line.split(" ")
    stack.last.push({ name:, type: "file", size: size.to_i })
    next
  end

  if line.start_with?("$ cd")
    name = line[4..].strip
    if name == ".."
      stack.pop
    else
      stack.push(stack.last.find { _1[:type] == "dir" && _1[:name] == name }[:children])
    end
    next
  end

  if line.start_with?("dir ")
    name = line[4..].strip
    stack.last.push({ name:, type: "dir", children: [] })
  end
end

def directory_size(directory)
  directory[:children].map do |item|
    if item[:type] == "file"
      item[:size]
    else
      directory_size(item)
    end
  end.sum
end

def flatten_directories(directory)
  [directory, *directory[:children].select { _1[:type] == "dir" }.map { flatten_directories(_1) }].flatten
end

pp flatten_directories(directories).map { directory_size(_1) }.select { _1 <= 100_000 }.sum
