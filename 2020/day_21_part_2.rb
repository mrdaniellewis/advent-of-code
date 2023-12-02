# frozen_string_literal: true

data = $stdin.read

ingrediants = {}
allergens = {}

data.split("\n").each_with_index do |line, food|
  listed_ingrediants, listed_allergens = /^(.*?)(?: \(contains (.+)\))?$/.match(line).captures
  listed_ingrediants = listed_ingrediants.split(" ")
  listed_allergens = listed_allergens&.split(", ") || []

  listed_allergens.each do |allergen|
    allergens[allergen] ||= {}
    listed_ingrediants.each do |ingrediant|
      allergens[allergen][ingrediant] ||= []
      allergens[allergen][ingrediant] << food
    end
  end
end

allergens.each do |_allergen, potential_ingrediants|
  max = potential_ingrediants.values.map(&:length).max
  potential_ingrediants.select! do |_ingrediant, foods|
    foods.length == max
  end
end

loop do
  allergen, ingredient_hash = allergens.find { _2.length == 1 }
  break unless allergen

  ingredient = ingredient_hash.keys.first

  ingrediants[ingredient] = allergen

  allergens.delete(allergen)

  allergens.each do |_, potential_ingrediants|
    potential_ingrediants.reject! { _1 == ingredient }
  end
end

puts ingrediants.to_a.sort_by { _2 }.map(&:first).join(",")
