require 'minitest/autorun'
require_relative './5'

class TestRun < Minitest::Test
  def setup
    super
  end

  def test_file_read
    almanac = read_file("5/test")
    assert almanac.class == Hash
    assert_equal [79, 14, 55, 13], almanac[:seeds]
    assert_equal 7, almanac[:mappings].size
    assert_equal [50, 98, 2], almanac[:mappings][0][0]
    assert_equal [52, 50, 48], almanac[:mappings][0][1]
    assert_equal [0, 11, 42], almanac[:mappings][2][1]
    assert_equal [56, 93, 4], almanac[:mappings][6][1]
  end

  def test_find_e2e_mapping
    almanac = read_file("5/test")
    assert_equal 82, find_e2e_mapping(79, almanac)
    assert_equal 43, find_e2e_mapping(14, almanac)
    assert_equal 86, find_e2e_mapping(55, almanac)
    assert_equal 35, find_e2e_mapping(13, almanac)
  end

  def test_find_mappings_all_seeds
    almanac = read_file("5/test")
    assert_equal 35, find_mappings_all_seeds(almanac)
  end

end