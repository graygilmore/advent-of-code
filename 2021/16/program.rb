require './base'

class PartOne
  def initialize(input = Base.raw_input('2021/16/input.txt'))
    @input = input
    @packets = []
  end

  def solution
    digest_packet([input].pack('H*').unpack('B*').first)
    @packets.sum { _1[:version] }
  end

  private

  attr_reader :input

  def digest_packet(binary)
    return if binary.chars.all?("0")

    packet = {}

    packet[:version] = binary.slice(0, 3).to_i(2)
    packet[:type_id] = binary.slice(3, 3).to_i(2)

    if packet[:type_id] != 4
      packet[:bit_length] = binary[6].to_i == 0 ? 15 : 11

      @packets << packet

      digest_packet(binary[(7 + packet[:bit_length])..-1])
    else
      counting = true
      value = ""
      current = 6
      while counting
        next_five = binary.slice(current, 5)
        current += 5

        if next_five[0] == "0"
          value += next_five[1..-1]
          packet[:literal_value] = value.to_i(2)
          counting = false

          @packets << packet


          digest_packet(binary[current..-1])
        else
          value += next_five[1..-1]
        end
      end
    end
  end
end

class PartTwo < PartOne
  def solution

  end

  private
end

class Test < Minitest::Test
  def test_part_one
    assert_equal 16, PartOne.new("8A004A801A8002F478").solution
    assert_equal 12, PartOne.new("620080001611562C8802118E34").solution
    assert_equal 23, PartOne.new("C0015000016115A2E0802F182340").solution
    assert_equal 31, PartOne.new("A0016C880162017C3686B18A3D4780").solution
    assert_equal 965, PartOne.new.solution
  end

  def test_part_two
    assert_equal 3, PartTwo.new("C200B40A82").solution
    assert_equal 54, PartTwo.new("04005AC33890").solution
    assert_equal 7, PartTwo.new("880086C3E88112").solution
    assert_equal 9, PartTwo.new("CE00C43D881120").solution
    assert_equal 1, PartTwo.new("D8005AC2A8F0").solution
    assert_equal 0, PartTwo.new("F600BC2D8F").solution
    assert_equal 0, PartTwo.new("9C005AC2F8F0").solution
    assert_equal 1, PartTwo.new("9C0141080250320F1802104A08").solution
    assert_equal 0, PartTwo.new.solution
  end

  def input
    <<~INPUT
    INPUT
  end
end
