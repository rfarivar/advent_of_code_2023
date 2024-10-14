require 'minitest/autorun'
require_relative './5'

class TestRun < Minitest::Test
  def setup
    super
    @almanac= read_file("5/test")
  end

  def test_file_read
    assert @almanac.class == Hash
    assert_equal [79, 14, 55, 13], @almanac[:seeds]
    assert_equal 7, @almanac[:mappings].size
    assert_equal [50, 98, 2], @almanac[:mappings][0][0]
    assert_equal [52, 50, 48], @almanac[:mappings][0][1]
    assert_equal [0, 11, 42], @almanac[:mappings][2][1]
    assert_equal [56, 93, 4], @almanac[:mappings][6][1]
  end

  def test_e2e_mapping
    assert_equal 82, e2e_mapping(79, @almanac)
    assert_equal 43, e2e_mapping(14, @almanac)
    assert_equal 86, e2e_mapping(55, @almanac)
    assert_equal 35, e2e_mapping(13, @almanac)
  end

  def test_find_mappings_all_seeds_round_
    assert_equal 35, find_mappings_all_seeds_round_1(@almanac)
  end

  # def test_find_mappings_all_seeds_round_2
  #   almanac = read_file("5/test")
  #   assert_equal 46, find_mappings_all_seeds_round_2(almanac)
  # end

  def test_seeds_array_to_ranges
    assert_equal [
                   {start: 79, length:14},
                   {start: 55, length:13}],
                 seeds_array_to_ranges(@almanac[:seeds])
  end

  def test_find_range_end
    range_first_0 = seeds_array_to_ranges(@almanac[:seeds])[0]
    expected_first_0_range = {start: 79, end: 81, length: 3}
    assert_equal expected_first_0_range, find_first_sub_range(range_first_0, @almanac)

    range_first_1 = {start:82, length: 11}
    expected_first_1_range = {start: 82, end: 91, length: 10}
    assert_equal expected_first_1_range, find_first_sub_range(range_first_1, @almanac)

    range_first_2 = {start:92, length: 1}
    expected_first_2_range = {start: 92, end: 92, length: 1}
    assert_equal expected_first_2_range, find_first_sub_range(range_first_2, @almanac)

    range_second_0 = seeds_array_to_ranges(@almanac[:seeds])[1]
    expected_first_range = {start: 55, end: 58, length: 4}
    assert_equal expected_first_range, find_first_sub_range(range_second_0, @almanac)

    range_second_1 = {start:59, length: 9}
    expected_second_1_range = {start: 59, end: 61, length: 3}
    assert_equal expected_second_1_range, find_first_sub_range(range_second_1, @almanac)

    range_second_2 = {start:62, length: 6}
    expected_second_2_range = {start: 62, end: 65, length: 4}
    assert_equal expected_second_2_range, find_first_sub_range(range_second_2, @almanac)

    range_second_3 = {start:66, length: 2}
    expected_second_3_range = {start: 66, end: 67, length: 2}
    assert_equal expected_second_3_range, find_first_sub_range(range_second_3, @almanac)
  end

  def test_extract_sub_ranges
    range_first = seeds_array_to_ranges(@almanac[:seeds])[0]
    range_second = seeds_array_to_ranges(@almanac[:seeds])[1]

    expected_ranges =  [
      {start: 79, length: 3, end: 81},
      {start: 82, length: 10, end: 91},
      {start: 92, length: 1, end: 92}
    ]
    assert_equal expected_ranges, extract_sub_ranges(range_first, @almanac).reverse

    expected_ranges =  [
      {start: 55, length: 4, end: 58},
      {start: 59, length: 3, end: 61},
      {start: 62, length: 4, end: 65},
      {start: 66, length: 2, end: 67}
    ]
    assert_equal expected_ranges, extract_sub_ranges(range_second, @almanac).reverse
  end

  def test_find_lowest_location_number
    assert_equal 46, find_lowest_location_number(@almanac)
  end
end

# mapping 79 ==> 82
# mapping 80 ==> 83
# mapping 81 ==> 84
#
# mapping 82 ==> 46
# mapping 83 ==> 47
# mapping 84 ==> 48
# mapping 85 ==> 49
# mapping 86 ==> 50
# mapping 87 ==> 51
# mapping 88 ==> 52
# mapping 89 ==> 53
# mapping 90 ==> 54
# mapping 91 ==> 55
#
# mapping 92 ==> 60
######### mapping 93 ==> 68
#
# ========================
# mapping 55 ==> 86
# mapping 56 ==> 87
# mapping 57 ==> 88
# mapping 58 ==> 89
#
# mapping 59 ==> 94
# mapping 60 ==> 95
# mapping 61 ==> 96
#
# mapping 62 ==> 56
# mapping 63 ==> 57
# mapping 64 ==> 58
# mapping 65 ==> 59
#
# mapping 66 ==> 97
# mapping 67 ==> 98
######### mapping 68 ==> 99