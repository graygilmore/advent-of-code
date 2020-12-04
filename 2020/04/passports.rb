require './base'

class PartOne
  def initialize(input = Base.raw_input('2020/04/input.txt'))
    @input = input
  end

  def solution
    passports.count { |passport| valid?(passport) }
  end

  private

  attr_reader :input, :passports

  def passports
    @passports ||= begin
      input.split(/\n{2,}/)
    end
  end

  def valid?(passport)
    [
      'byr',
      'iyr',
      'eyr',
      'hgt',
      'hcl',
      'ecl',
      'pid',
    ].all? { |field| passport.include?(field) }
  end
end

class PartTwo < PartOne
  def solution; end
end

class Test < Minitest::Test
  def test_part_one
    assert_equal 2, PartOne.new(
      <<~INPUT
        ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
        byr:1937 iyr:2017 cid:147 hgt:183cm

        iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
        hcl:#cfa07d byr:1929

        hcl:#ae17e1 iyr:2013
        eyr:2024
        ecl:brn pid:760753108 byr:1931
        hgt:179cm

        hcl:#cfa07d eyr:2025 pid:166559648
        iyr:2011 ecl:brn hgt:59in
      INPUT
    ).solution
    assert_equal 213, PartOne.new().solution
  end

  def test_part_two
  end
end
