require './base'

class PartOne
  def initialize(input = Base.raw_input('2020/07/input.txt'))
    @input = input
  end

  def solution
    bag_rules.count do |color, included_bag_colors|
      bag_contains_gold?(color)
    end
  end

  def bag_contains_gold?(color)
    bag_rules[color].include?('shiny gold') || bag_rules[color].any? do |included_color|
      bag_contains_gold?(included_color)
    end
  end

  private

  attr_reader :input, :bag_rules

  def bag_rules
    @bag_rules ||= begin
      input.split(/\n/).map do |rule|
        outer_bag, inner_bags = rule.split('bags contain').map(&:strip)

        if inner_bags == 'no other bags.'
          [
            outer_bag,
            []
          ]
        else

          [
            outer_bag,
            inner_bags.split(', ').map do |bag|
              _, count, color = bag.split(/(\d) /)

              color.gsub(/bags(.)?|bag(.)?/, '').strip
            end
          ]
        end
      end.to_h
    end
  end
end

class PartTwo < PartOne
end

class Test < Minitest::Test
  def test_part_one
    assert_equal 4, PartOne.new(
      <<~INPUT
        light red bags contain 1 bright white bag, 2 muted yellow bags.
        dark orange bags contain 3 bright white bags, 4 muted yellow bags.
        bright white bags contain 1 shiny gold bag.
        muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
        shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
        dark olive bags contain 3 faded blue bags, 4 dotted black bags.
        vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
        faded blue bags contain no other bags.
        dotted black bags contain no other bags.
      INPUT
    ).solution
    assert_equal 268, PartOne.new.solution
  end

  def test_part_two
  end
end
