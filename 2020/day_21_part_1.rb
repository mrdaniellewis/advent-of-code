# frozen_string_literal: true

data = $stdin.read

foods = {}
allergens = {}

data.split("\n").each do |line|
  ingrediants, listed_allergens = /^(.*?)(?: \(contains (.+)\))?$/.match(line).captures

  listed_allergens = listed_allergens&.split(", ") || []
  ingrediants = ingrediants.split(" ")

  ingrediants.each do |item|
    foods[item] = nil
  end

  listed_allergens.each do |item|
    allergens[item] ||= []
  end
end

pp foods
