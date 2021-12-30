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
  class Packet
    def initialize(bits)
      @bits = bits
      @version = bits.slice!(0, 3).to_i(2)
      @type_id = bits.slice!(0, 3).to_i(2)
      @value = compute_value
    end
    attr_reader :bits, :version, :type_id, :value

    private

    def literal_value
      return unless type_id == 4

      @literal_value ||= begin
        number = ""
        loop do
          next_five = bits.slice!(0, 5)
          number << next_five
          break if next_five[0] == "0"
        end
        number.to_i(2)
      end
    end

    def length_type_id
      @length_type_id ||= bits.slice!(0)
    end

    def subpacket_length
      @subpacket_length ||= begin
        bits_to_check = length_type_id == "0" ? 15 : 11
        bits.slice!(0, bits_to_check).to_i(2)
      end
    end

    def subpackets
      @subpackets ||= begin
        packets = []

        if length_type_id == "0"
          remaining_bits = bits.slice!(0, subpacket_length)

          while remaining_bits.length > 0
            packet = Packet.new(remaining_bits)
            packets << packet
            remaining_bits = packet.bits
          end
        else
          packets_to_build = subpacket_length
          packets_to_build.times do
            packet = Packet.new(bits)
            packets << packet
            bits = packet.bits
          end
        end

        packets
      end
    end

    def compute_value
      return literal_value if type_id == 4

      subpacket_values = subpackets.map { |p| p.value }

      case type_id
      when 0
        subpacket_values.sum
      when 1
        subpacket_values.reduce(:*)
      when 2
        subpacket_values.min
      when 3
        subpacket_values.max
      when 5
        subpacket_values[0] > subpacket_values[1] ? 1 : 0
      when 6
        subpacket_values[0] < subpacket_values[1] ? 1 : 0
      when 7
        subpacket_values[0] == subpacket_values[1] ? 1 : 0
      end
    end
  end

  def solution
    Packet.new([input].pack('H*').unpack('B*').first).value
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
