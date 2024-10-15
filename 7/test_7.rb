require "minitest/autorun"
require_relative "7.rb"

class Test7 < Minitest::Test
  def setup
    super
    @hand_five_of_a_kind = Hand.new("AAAAA")
    @hand_five_of_a_kind_variant = Hand.new("KKKKK")

    @hand_four_of_a_kind = Hand.new("AAAAK")
    @hand_four_of_a_kind_variant = Hand.new("AAAAQ")

    @hand_full_house = Hand.new("AAAKK")
    @hand_full_house_variant = Hand.new("KKKAA")

    @hand_three_of_a_kind = Hand.new("AAAKQ")
    @hand_three_of_a_kind_variant = Hand.new("KKKAQ")

    @hand_two_pair = Hand.new("AA4KK")
    @hand_two_pair_variant = Hand.new("AA3KK")

    @hand_one_pair = Hand.new("AA532")
    @hand_one_pair_variant = Hand.new("AA432")

    @hand_nothing = Hand.new("73456")
    @hand_nothing_variant = Hand.new("23456")

    @hand_with_joker = Hand.new("AJA34", 1, true)

    @hands = read_hands_round_1("7/test")
  end

  def test_hand_object
    hand = Hand.new("32T3K")
    expected_has_hand = {"3"=>2, "2"=>1, "T"=>1, "K"=>1}
    assert_equal expected_has_hand, hand.hand_hash
  end

  def test_five_of_a_kind
    assert @hand_five_of_a_kind.five_of_a_kind?
    refute @hand_four_of_a_kind.five_of_a_kind?
  end

  def test_four_of_a_kind
    assert @hand_four_of_a_kind.four_of_a_kind?
    refute @hand_three_of_a_kind.four_of_a_kind?
  end

  def test_full_house
    assert @hand_full_house.full_house?
    refute @hand_three_of_a_kind.full_house?
  end

  def test_three_of_a_kind
    assert @hand_three_of_a_kind.three_of_a_kind?
    refute @hand_full_house.three_of_a_kind?
  end

  def test_two_pair
    assert @hand_two_pair.two_pair?
    refute @hand_one_pair.two_pair?
  end

  def test_one_pair
    assert @hand_one_pair.one_pair?
    refute @hand_nothing.one_pair?
  end

  def test_nothing
    assert @hand_nothing.nothing?
    refute @hand_one_pair.nothing?
  end

  def test_hand_category_value
    assert_equal 0, @hand_five_of_a_kind.category_value
    assert_equal 1, @hand_four_of_a_kind.category_value
    assert_equal 2, @hand_full_house.category_value
    assert_equal 3, @hand_three_of_a_kind.category_value
    assert_equal 4, @hand_two_pair.category_value
    assert_equal 5, @hand_one_pair.category_value
    assert_equal 6, @hand_nothing.category_value
  end

  def test_hand_comparison
    assert_equal 1, @hand_five_of_a_kind <=> @hand_five_of_a_kind_variant
    assert_equal -1 , @hand_four_of_a_kind_variant <=> @hand_four_of_a_kind
    assert_equal 1, @hand_full_house <=> @hand_full_house_variant
    assert_equal -1, @hand_three_of_a_kind_variant <=> @hand_three_of_a_kind
    assert_equal 1, @hand_two_pair <=> @hand_two_pair_variant
    assert_equal -1, @hand_one_pair_variant <=> @hand_one_pair
    assert_equal 1, @hand_nothing <=> @hand_nothing_variant
  end

  def test_sorting
    assert_equal 6440, total_winnings_round_1('7/test')
  end

end