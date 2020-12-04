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
    passports.count { |passport| Passport.new(passport, strict: true).valid? }
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
    required_fields.all? { |field_name| passport[field_name] }
  end

  def required_fields
    %w(byr iyr eyr hgt hcl ecl pid)
  end

  private

  attr_reader :passport
end

class StrictPassportValidator
  def initialize(passport)
    @passport = passport
  end

  def valid?
    base_validator = PassportValidator.new(passport)

    base_validator.valid? &&
      base_validator.required_fields.all? { |field| send("valid_#{field}?") }
  end

  def valid_byr?
    (1920..2002).include?(passport['byr'].to_i)
  end

  def valid_iyr?
    (2010..2020).include?(passport['iyr'].to_i)
  end

  def valid_eyr?
    (2020..2030).include?(passport['eyr'].to_i)
  end

  def valid_hgt?
    if passport['hgt'].include?('cm')
      (150..193).include?(passport['hgt'].to_i)
    elsif passport['hgt'].include?('in')
      (59..76).include?(passport['hgt'].to_i)
    else
      false
    end
  end

  def valid_hcl?
    passport['hcl'].match?(/\A#[0-9a-fA-F]{6}\z/)
  end

  def valid_ecl?
    %w(amb blu brn gry grn hzl oth).include?(passport['ecl'])
  end

  def valid_pid?
    passport['pid'].match?(/\A[0-9]{9}\z/)
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

  def test_strict_passport
    assert_equal false, Passport.new(
      <<~INPUT,
        eyr:1972 cid:100
        hcl:#18171d ecl:amb hgt:170 pid:186cm iyr:2018 byr:1926
      INPUT
      strict: true
    ).valid?

    assert_equal true, Passport.new(
      <<~INPUT,
        pid:087499704 hgt:74in ecl:grn iyr:2012 eyr:2030 byr:1980
        hcl:#623a2f
      INPUT
      strict: true
    ).valid?
  end

  def test_valid_byr
    assert_equal true, StrictPassportValidator.new({ 'byr' => '2002' }).valid_byr?
    assert_equal false, StrictPassportValidator.new({ 'byr' => '1919' }).valid_byr?
    assert_equal false, StrictPassportValidator.new({ 'byr' => '2003' }).valid_byr?
  end

  def test_valid_iyr
    assert_equal true, StrictPassportValidator.new({ 'iyr' => '2010' }).valid_iyr?
    assert_equal false, StrictPassportValidator.new({ 'iyr' => '2009' }).valid_iyr?
    assert_equal false, StrictPassportValidator.new({ 'iyr' => '2021' }).valid_iyr?
  end

  def test_valid_eyr
    assert_equal true, StrictPassportValidator.new({ 'eyr' => '2020' }).valid_eyr?
    assert_equal false, StrictPassportValidator.new({ 'eyr' => '2019' }).valid_eyr?
    assert_equal false, StrictPassportValidator.new({ 'eyr' => '2031' }).valid_eyr?
  end

  def test_valid_hgt
    assert_equal true, StrictPassportValidator.new({ 'hgt' => '60in' }).valid_hgt?
    assert_equal true, StrictPassportValidator.new({ 'hgt' => '190cm' }).valid_hgt?
    assert_equal false, StrictPassportValidator.new({ 'hgt' => '190in' }).valid_hgt?
    assert_equal false, StrictPassportValidator.new({ 'hgt' => '190' }).valid_hgt?
  end

  def test_valid_hcl
    assert_equal true, StrictPassportValidator.new({ 'hcl' => '#123abc' }).valid_hcl?
    assert_equal false, StrictPassportValidator.new({ 'hcl' => '#123abz' }).valid_hcl?
    assert_equal false, StrictPassportValidator.new({ 'hcl' => '123abc' }).valid_hcl?
  end

  def test_valid_ecl
    assert_equal true, StrictPassportValidator.new({ 'ecl' => 'brn' }).valid_ecl?
    assert_equal false, StrictPassportValidator.new({ 'ecl' => 'wat' }).valid_ecl?
  end

  def test_valid_pid
    assert_equal true, StrictPassportValidator.new({ 'pid' => '000000001' }).valid_pid?
    assert_equal false, StrictPassportValidator.new({ 'pid' => '0123456789' }).valid_pid?
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
