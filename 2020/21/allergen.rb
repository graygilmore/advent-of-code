require './base'

class PartOne
  def initialize(input = Base.raw_input('2020/21/input.txt'))
    @input = input
  end

  def solution
    @known = []

    while allergens.any? { |_, v| v[:possibilities].count > 1 } do
      filter(allergens)
    end
    
    all_ingredients.reject { |k,v| @known.include?(k) }.values.sum
  end

  def filter(allergens)
    allergens.each do |_, v|
      next if v[:possibilities].count == 1
      v[:possibilities].select! do |ingredient, count| 
        count >= v[:count] && !@known.include?(ingredient)
      end
      if v[:possibilities].count == 1
        @known << v[:possibilities].keys.first
      end
    end
  end

  private

  attr_reader :input

  def all_ingredients
    @all_ingredients ||= begin
      input.split(/\n/).map do |dish|
        ingredients, _ = dish.split(/ \(contains (.*)\)/)
        ingredients.split(' ')
      end.flatten.tally
    end
  end

  def allergens
    @allergens ||= begin
      hash = {}
      input.split(/\n/).map do |dish|
        ingredients, next_allergens = dish.split(/ \(contains (.*)\)/)

        next_allergens.split(', ').each do |allergen|
          if hash[allergen]
            hash[allergen][:count] += 1
            hash[allergen][:possibilities] = 
              hash[allergen][:possibilities].merge(ingredients.split(' ').tally) { |k,o,n| o + n }
          else
            hash[allergen] = {}
            hash[allergen][:count] = 1
            hash[allergen][:possibilities] = ingredients.split(' ').tally
          end
        end
      end
      hash
    end
  end
end

class PartTwo < PartOne
  def solution
    0
  end
end

class Test < Minitest::Test
  def test_part_one
    assert_equal 5, PartOne.new(input).solution
    assert_equal 2786, PartOne.new.solution
  end

  def test_part_two
    assert_equal 0, PartTwo.new(input).solution
    assert_equal 0, PartTwo.new.solution
  end

  def input
    <<~INPUT
      mxmxvkd kfcds sqjhc nhms (contains dairy, fish)
      trh fvjkl sbzzf mxmxvkd (contains dairy)
      sqjhc fvjkl (contains soy)
      sqjhc mxmxvkd sbzzf (contains fish)
    INPUT
  end
end
