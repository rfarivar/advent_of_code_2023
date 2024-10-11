require "minitest/autorun"
require_relative "./4"

class TestRun < Minitest::Test
  def setup
    super
    lines = %{Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
              Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
              Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
              Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
              Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
              Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11}
    @lines = lines.split("\n").map(&:strip)
    @cards = @lines.map{ |line| read_card(line)}
  end

  def test_read_card
    assert_equal [41, 48, 83, 86, 17], read_card(@lines[0])[:winning_numbers]
    assert_equal [83, 86, 6, 31, 17, 9, 48, 53], read_card(@lines[0])[:have_numbers]
    assert_equal 1, read_card(@lines[0])[:card_number]
  end

  def test_card_points
    assert_equal 8, card_points(@cards[0])
    assert_equal 2, card_points(@cards[1])
    assert_equal 2, card_points(@cards[2])
    assert_equal 1, card_points(@cards[3])
    assert_equal 0, card_points(@cards[4])
    assert_equal 0, card_points(@cards[5])
  end

  def test_calculate_total_points
    assert_equal 13, calculate_total_points_round_1(@lines)
  end

  def test_card_matches
    assert_equal 4, card_matches(@cards[0])
    assert_equal 2, card_matches(@cards[1])
    assert_equal 2, card_matches(@cards[2])
    assert_equal 1, card_matches(@cards[3])
    assert_equal 0, card_matches(@cards[4])
    assert_equal 0, card_matches(@cards[5])
  end

  def test_process_round_2
    assert_equal 30, process_round_2(@lines)
  end
end