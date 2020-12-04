require './base'

class PartOne
  def initialize(input = Base.raw_input('2020/04/input.txt'))
    @input = input
  end

  def solution
    passports.count { |passport| Passport.new(passport).valid? }
  end

  private

  attr_reader :input, :passports

  def passports
    @passports ||= begin
      input.split(/\n{2,}/)
    end
  end
end

class PartTwo < PartOne
  def solution
    formatted_passports.count { |passport| valid?(passport) }
  end

  private

  attr_reader :formatted_passports

  def valid?(passport)
    [
      'byr',
      'iyr',
      'eyr',
      'hgt',
      'hcl',
      'ecl',
      'pid',
    ].all? do|field_name|
      field = passport.find { |f| f.start_with?(field_name) }
      field_valid?(field_name, field)
    end
  end

  def field_valid?(field_name, field)
    return false unless field

    value = field.split("#{field_name}:")[1]

    case field_name
      when 'byr'
        value.to_i >= 1920 && value.to_i <= 2002
      when 'iyr'
        value.to_i >= 2010 && value.to_i <= 2020
      when 'eyr'
        value.to_i >= 2020 && value.to_i <= 2030
      when 'hgt'
        if value.include?('cm')
          value.to_i >= 150 && value.to_i <= 193
        elsif value.include?('in')
          value.to_i >= 59 && value.to_i <= 76
        else
          false
        end
      when 'hcl'
        value.match?(/\A#[0-9a-zA-Z]{6}\z/)
      when 'ecl'
        %w(amb blu brn gry grn hzl oth).include?(value)
      when 'pid'
        value.match?(/\A[0-9]{9}\z/)
      end
  end

  def formatted_passports
    @formatted_passports ||= passports.map(&:split)
  end
end

class Passport
  def initialize(raw_data, strict: false)
    @raw_data = raw_data
    @strict = strict
  end

  def valid?
    passport_validator_class.new(formatted_passport).valid?
  end

  private

  attr_reader :raw_data, :strict

  def passport_validator_class
    strict ? StrictPassportValidator : PassportValidator
  end

  def formatted_passport
    raw_data.split.map { |f| f.split(':') }.to_h
  end
end

class PassportValidator
  def initialize(passport)
    @passport = passport
  end

  def valid?
    [
      'byr',
      'iyr',
      'eyr',
      'hgt',
      'hcl',
      'ecl',
      'pid',
    ].all? { |field_name| passport[field_name] }
  end

  private

  attr_reader :passport
end

class StrictPassportValidator
  def initialize(passport)
    @passport = passport
  end

  def valid?
    false
  end

  private

  attr_reader :passport
end

class Test < Minitest::Test
  def test_passport
    assert_equal false, Passport.new(
      <<~INPUT
        iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
        hcl:#cfa07d byr:1929
      INPUT
    ).valid?

    assert_equal true, Passport.new(
      <<~INPUT
        ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
        byr:1937 iyr:2017 cid:147 hgt:183cm
      INPUT
    ).valid?

    assert_equal true, Passport.new(
      <<~INPUT
        hcl:#ae17e1 iyr:2013
        eyr:2024
        ecl:brn pid:760753108 byr:1931
        hgt:179cm
      INPUT
    ).valid?
  end

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
    assert_equal 0, PartTwo.new(
      <<~INPUT
        eyr:1972 cid:100
        hcl:#18171d ecl:amb hgt:170 pid:186cm iyr:2018 byr:1926

        iyr:2019
        hcl:#602927 eyr:1967 hgt:170cm
        ecl:grn pid:012533040 byr:1946

        hcl:dab227 iyr:2012
        ecl:brn hgt:182cm pid:021572410 eyr:2020 byr:1992 cid:277

        hgt:59cm ecl:zzz
        eyr:2038 hcl:74454a iyr:2023
        pid:3556412378 byr:2007
      INPUT
    ).solution

    assert_equal 4, PartTwo.new(
      <<~INPUT
        pid:087499704 hgt:74in ecl:grn iyr:2012 eyr:2030 byr:1980
        hcl:#623a2f

        eyr:2029 ecl:blu cid:129 byr:1989
        iyr:2014 pid:896056539 hcl:#a97842 hgt:165cm

        hcl:#888785
        hgt:164cm byr:2001 iyr:2015 cid:88
        pid:545766238 ecl:hzl
        eyr:2022

        iyr:2010 hgt:158cm hcl:#b6652a ecl:blu byr:1944 eyr:2021 pid:093154719
      INPUT
    ).solution

    assert_equal 147, PartTwo.new.solution
  end
end
