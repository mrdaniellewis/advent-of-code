# frozen_string_literal: true

data = $stdin.read

directories = { name: "/", type: "dir", children: [], level: 1 }

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
    stack.last.push({ name:, type: "dir", children: [], level: stack.length })
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

$free = 70_000_000 - directory_size(directories)

pp flatten_directories(directories)
  .map { [_1, directory_size(_1)] }
  .sort { |a, b| a[1] - b[1] }
  .find { $free + directory_size(_1[0]) >= 30_000_000 }[1]
