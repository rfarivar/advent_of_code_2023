require "minitest/autorun"
require_relative "6.rb"

class Test6 < Minitest::Test
  def setup
    super
    @races_round_1 = read_races_round_1("6/test")
    @races_round_2 = read_races_round_2("6/test")
  end

  def test_read_race
    races = [{time: 7, distance:9},
             {time: 15, distance:40},
             {time: 30, distance:200},
    ]
    assert_equal races, read_races_round_1("6/test")
  end

  def test_calculate_winning_range_for_one_race
    assert_equal (2..5).to_a, calculate_winning_range_for_one_race(@races_round_1[0])
    assert_equal (4..11).to_a, calculate_winning_range_for_one_race(@races_round_1[1])
    assert_equal (11..19).to_a, calculate_winning_range_for_one_race(@races_round_1[2])
  end

  def test_number_of_ways_to_beat_record
    assert_equal 288, number_of_ways_to_beat_record_round_1("6/test")
  end

  def test_number_of_ways_to_beat_record_round_2
    assert_equal 71503, number_of_ways_to_beat_record_round_2("6/test")
  end

end
