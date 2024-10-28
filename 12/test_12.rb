require "minitest/autorun"
require_relative "12"

class Test12 < Minitest::Test
  def setup
    super
    @springs = HotSprings.new("12/test")
  end

  def test_read
    assert_equal ["???.###", [1,1,3]], @springs.spring_rows[0]
    assert_equal ["?#?#?#?#?#?#?#?", [1,3,1,6]], @springs.spring_rows[2]
  end

  def test_count_possible
    assert_equal 1, @springs.count_possible(0)
    assert_equal 4, @springs.count_possible(1)
    assert_equal 1, @springs.count_possible(2)
    assert_equal 1, @springs.count_possible(3)
    assert_equal 4, @springs.count_possible(4)
    assert_equal 10, @springs.count_possible(5)
    assert_equal 7, @springs.count_possible(6)
  end

  def test_sum_all_counts
    assert_equal 28, @springs.sum_all_counts
  end
end