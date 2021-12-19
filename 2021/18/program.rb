require 'json'
require './base'

class PartOne
  def initialize(input = Base.raw_input('2021/18/input.txt'))
    @input = input
  end

  def solution
    summed_numbers = snailfish_numbers.first
    snailfish_numbers.each.with_index do |number, index|
      next if index == 0
      num = summed_numbers.dup
      reduced = reduce_number("[#{num},#{number}]")
      summed_numbers = reduced
    end
    summed_numbers
  end

  def magnitude
    calc_magnitude(JSON.parse(solution))
  end

  private

  attr_reader :input

  def reduce_number(number)
    stack = []
    number.chars.each.with_index do |char, i|
      stack.push(char) if char == "["
      stack.pop if char == "]"

      if stack.size == 5
        slice_length = 5

        while number[i + slice_length - 1] != "]"
          if number[i + slice_length - 1].nil?
            return number
          end
          slice_length += 1
        end

        left, right = JSON.parse(number.slice(i, slice_length))

        number[i..i+(slice_length-1)] = "0"

        closest_left_index = closest_index(number, i - 1, "left")
        closest_right_index = closest_index(number, i + 1, "right")

        if closest_right_index
          number[closest_right_index] = (right + number[closest_right_index].to_i).to_s
        end

        if closest_left_index
          number[closest_left_index] = (left + number[closest_left_index].to_i).to_s
        end

        reduce_number(number)
        break
      end
    end

    number.chars.each.with_index do |char, i|
      two_chars = number[i..i+1]
      if two_chars == two_chars.to_i.to_s
        number[i..i+1] = "[#{two_chars.to_i/2},#{(two_chars.to_i/2.to_f).ceil}]"
        reduce_number(number)
        break
      end
    end

    number
  end

  def closest_index(number, index, dir)
    return nil if index < 0
    char = number[index]

    return nil if char.nil?

    double_index = dir == "left" ? (index-1..index) : (index..index+1)

    if number[double_index] == number[double_index].to_i.to_s
      return double_index
    elsif char == char.to_i.to_s
      return index
    else
      closest_index(number, dir == "left" ? index - 1 : index + 1, dir)
    end
  end

  def calc_magnitude(number)
    new_number = number.dup

    n1 = number[0].is_a?(Integer) ? number[0] * 3 : calc_magnitude(new_number[0]) * 3
    n2 = number[1].is_a?(Integer) ? number[1] * 2 : calc_magnitude(new_number[1]) * 2

    n1 + n2
  end

  def snailfish_numbers
    @snailfish_numbers ||= input.lines.map(&:chomp)
  end
end

class PartTwo < PartOne
  def solution
    snailfish_numbers.permutation(2).map do |number|
      summed = reduce_number("[#{number.join(',')}]")
      calc_magnitude(JSON.parse(summed))
    end.max
  end
end

class Test < Minitest::Test
  def test_large_example_1
    assert_equal "[[[[4,0],[5,4]],[[7,7],[6,0]]],[[8,[7,7]],[[7,9],[5,0]]]]", PartOne.new(large_example_part_1).solution
  end
  def test_large_example_2
    assert_equal "[[[[6,7],[6,7]],[[7,7],[0,7]]],[[[8,7],[7,7]],[[8,8],[8,0]]]]", PartOne.new(large_example_part_2).solution
  end
  def test_large_example_3
    assert_equal "[[[[7,0],[7,7]],[[7,7],[7,8]]],[[[7,7],[8,8]],[[7,7],[8,7]]]]", PartOne.new(large_example_part_3).solution
  end
  def test_large_example_4
    assert_equal "[[[[7,7],[7,8]],[[9,5],[8,7]]],[[[6,8],[0,8]],[[9,9],[9,0]]]]", PartOne.new(large_example_part_4).solution
  end
  def test_large_example_5
    assert_equal "[[[[6,6],[6,6]],[[6,0],[6,7]]],[[[7,7],[8,9]],[8,[8,1]]]]", PartOne.new(large_example_part_5).solution
  end
  def test_large_example_6
    assert_equal "[[[[6,6],[7,7]],[[0,7],[7,7]]],[[[5,5],[5,6]],9]]", PartOne.new(large_example_part_6).solution
  end
  def test_large_example_7
    assert_equal "[[[[7,8],[6,7]],[[6,8],[0,8]]],[[[7,7],[5,0]],[[5,5],[5,6]]]]", PartOne.new(large_example_part_7).solution
  end
  def test_large_example_8
    assert_equal "[[[[7,7],[7,7]],[[8,7],[8,7]]],[[[7,0],[7,7]],9]]", PartOne.new(large_example_part_8).solution
  end
  def test_large_example_9
    assert_equal "[[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]", PartOne.new(large_example_part_9).solution
  end

  def test_summed_numbers
    assert_equal "[[[[0,7],4],[[7,8],[6,0]]],[8,1]]", PartOne.new(small_input).solution
    assert_equal "[[[[1,1],[2,2]],[3,3]],[4,4]]", PartOne.new(test_list_1).solution
    assert_equal "[[[[3,0],[5,3]],[4,4]],[5,5]]", PartOne.new(test_list_2).solution
    assert_equal "[[[[5,0],[7,4]],[5,5]],[6,6]]", PartOne.new(test_list_3).solution
    assert_equal "[[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]", PartOne.new(large_input).solution
    assert_equal "[[[[6,6],[7,6]],[[7,7],[7,0]]],[[[7,7],[7,7]],[[7,8],[9,9]]]]", PartOne.new(homework).solution
  end

  def test_magnitudes
    assert_equal 143, PartOne.new("[[1,2],[[3,4],5]]").magnitude
    assert_equal 1384, PartOne.new("[[[[0,7],4],[[7,8],[6,0]]],[8,1]]").magnitude
    assert_equal 445, PartOne.new("[[[[1,1],[2,2]],[3,3]],[4,4]]").magnitude
    assert_equal 791, PartOne.new("[[[[3,0],[5,3]],[4,4]],[5,5]]").magnitude
    assert_equal 1137, PartOne.new("[[[[5,0],[7,4]],[5,5]],[6,6]]").magnitude
    assert_equal 3488, PartOne.new("[[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]").magnitude
    assert_equal 4140, PartOne.new(homework).magnitude
    assert_equal 3305, PartOne.new.magnitude
  end

  def test_part_two
    assert_equal 3993, PartTwo.new(homework).solution
    assert_equal 4563, PartTwo.new.solution
  end

  def large_example_part_1
    <<~EXAMPLE
    [[[0,[4,5]],[0,0]],[[[4,5],[2,6]],[9,5]]]
    [7,[[[3,7],[4,3]],[[6,3],[8,8]]]]
    EXAMPLE
  end

  def large_example_part_2
    <<~EXAMPLE
    [[[[4,0],[5,4]],[[7,7],[6,0]]],[[8,[7,7]],[[7,9],[5,0]]]]
    [[2,[[0,8],[3,4]]],[[[6,7],1],[7,[1,6]]]]
    EXAMPLE
  end

  def large_example_part_3
    <<~EXAMPLE
    [[[[6,7],[6,7]],[[7,7],[0,7]]],[[[8,7],[7,7]],[[8,8],[8,0]]]]
    [[[[2,4],7],[6,[0,5]]],[[[6,8],[2,8]],[[2,1],[4,5]]]]
    EXAMPLE
  end

  def large_example_part_4
    <<~EXAMPLE
    [[[[7,0],[7,7]],[[7,7],[7,8]]],[[[7,7],[8,8]],[[7,7],[8,7]]]]
    [7,[5,[[3,8],[1,4]]]]
    EXAMPLE
  end

  def large_example_part_5
    <<~EXAMPLE
    [[[[7,7],[7,8]],[[9,5],[8,7]]],[[[6,8],[0,8]],[[9,9],[9,0]]]]
    [[2,[2,2]],[8,[8,1]]]
    EXAMPLE
  end

  def large_example_part_6
    <<~EXAMPLE
    [[[[6,6],[6,6]],[[6,0],[6,7]]],[[[7,7],[8,9]],[8,[8,1]]]]
    [2,9]
    EXAMPLE
  end

  def large_example_part_7
    <<~EXAMPLE
    [[[[6,6],[7,7]],[[0,7],[7,7]]],[[[5,5],[5,6]],9]]
    [1,[[[9,3],9],[[9,0],[0,7]]]]
    EXAMPLE
  end

  def large_example_part_8
    <<~EXAMPLE
    [[[[7,8],[6,7]],[[6,8],[0,8]]],[[[7,7],[5,0]],[[5,5],[5,6]]]]
    [[[5,[7,4]],7],1]
    EXAMPLE
  end

  def large_example_part_9
    <<~EXAMPLE
    [[[[7,7],[7,7]],[[8,7],[8,7]]],[[[7,0],[7,7]],9]]
    [[[[4,2],2],6],[8,7]]
    EXAMPLE
  end

  def test_list_1
    <<~INPUT
    [1,1]
    [2,2]
    [3,3]
    [4,4]
    INPUT
  end

  def test_list_2
    <<~INPUT
    [1,1]
    [2,2]
    [3,3]
    [4,4]
    [5,5]
    INPUT
  end

  def test_list_3
    <<~INPUT
    [1,1]
    [2,2]
    [3,3]
    [4,4]
    [5,5]
    [6,6]
    INPUT
  end

  def small_input
    <<~INPUT
      [[[[4,3],4],4],[7,[[8,4],9]]]
      [1,1]
    INPUT
  end

  def large_input
    <<~INPUT
      [[[0,[4,5]],[0,0]],[[[4,5],[2,6]],[9,5]]]
      [7,[[[3,7],[4,3]],[[6,3],[8,8]]]]
      [[2,[[0,8],[3,4]]],[[[6,7],1],[7,[1,6]]]]
      [[[[2,4],7],[6,[0,5]]],[[[6,8],[2,8]],[[2,1],[4,5]]]]
      [7,[5,[[3,8],[1,4]]]]
      [[2,[2,2]],[8,[8,1]]]
      [2,9]
      [1,[[[9,3],9],[[9,0],[0,7]]]]
      [[[5,[7,4]],7],1]
      [[[[4,2],2],6],[8,7]]
    INPUT
  end

  def homework
    <<~INPUT
      [[[0,[5,8]],[[1,7],[9,6]]],[[4,[1,2]],[[1,4],2]]]
      [[[5,[2,8]],4],[5,[[9,9],0]]]
      [6,[[[6,2],[5,6]],[[7,6],[4,7]]]]
      [[[6,[0,7]],[0,9]],[4,[9,[9,0]]]]
      [[[7,[6,4]],[3,[1,3]]],[[[5,5],1],9]]
      [[6,[[7,3],[3,2]]],[[[3,8],[5,7]],4]]
      [[[[5,4],[7,7]],8],[[8,3],8]]
      [[9,3],[[9,9],[6,[4,9]]]]
      [[2,[[7,7],7]],[[5,8],[[9,3],[0,2]]]]
      [[[[5,2],5],[8,[3,7]]],[[5,[7,5]],[4,4]]]
    INPUT
  end
end
