# frozen_string_literal: true

data = $stdin.read

ingrediants = {}
allergens = {}

data.split("\n").each_with_index do |line, food|
  listed_ingrediants, listed_allergens = /^(.*?)(?: \(contains (.+)\))?$/.match(line).captures
  listed_ingrediants = listed_ingrediants.split(" ")
  listed_allergens = listed_allergens&.split(", ") || []

  listed_ingrediants.each do |ingrediant|
    ingrediants[ingrediant] ||= []
    ingrediants[ingrediant] << food
  end

  listed_allergens.each do |allergen|
    allergens[allergen] ||= {}
    listed_ingrediants.each do |ingrediant|
      allergens[allergen][ingrediant] ||= []
      allergens[allergen][ingrediant] << food
    end
  end
end

potential_allergens = []

allergens.each do |_allergen, potential_ingrediants|
  max = potential_ingrediants.values.map(&:length).max
  potential_ingrediants.each do |ingrediant, foods|
    potential_allergens << ingrediant if foods.length == max
  end
end

ingrediants
  .reject do |ingrediant|
    potential_allergens.include?(ingrediant)
  end
  .map { _2.length }
  .sum
  .then { puts _1 }
