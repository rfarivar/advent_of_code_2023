require "minitest/autorun"
require_relative "9"

class Test9 < Minitest::Test
  def setup
    super
    @reports = read_file("9/test")
  end

  def test_input
    assert_equal [0, 3, 6, 9, 12, 15], @reports[0]
    assert_equal [1, 3, 6, 10, 15, 21], @reports[1]
    assert_equal [10, 13, 16, 21, 30, 45], @reports[2]
  end

  def test_difference_sequence
    assert_equal [3,3,3,3,3], difference_sequence(@reports[0])
    assert_equal [0,0,0,0], difference_sequence([3,3,3,3,3])
  end

  def test_all_sequences
    assert_equal [@reports[0], [3,3,3,3,3], [0,0,0,0]], all_sequences(@reports[0])
  end

  def test_extrapolate_last_digit
    assert_equal 18, extrapolate_last_digit(@reports[0])
    assert_equal 28, extrapolate_last_digit(@reports[1])
    assert_equal 68, extrapolate_last_digit(@reports[2])
  end

  def test_extrapolate_first_digit
    assert_equal -3, extrapolate_first_digit(@reports[0])
    assert_equal 0, extrapolate_first_digit(@reports[1])
    assert_equal 5, extrapolate_first_digit(@reports[2])
  end
  def test_sum_all_inputs
    assert_equal 114, sum_last_digit_extrapolation_for_all_inputs("9/test")
  end
end