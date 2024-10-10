require "minitest/autorun"
require_relative "./3"

class TestRun < Minitest::Test

  def setup
    @lines = %{467..114..
            ...*......
            ..35..633.
            ......#...
            617*......
            .....+.58.
            ..592.....
            ......755.
            ...$.*....
            .664.598..}
               .split("\n").map(&:strip)
  end

  def test_is_adjacent
    before_line = @lines[1]
    current_line = @lines[2]
    next_line = @lines[3]
    starting = 6
    ending = 8
    assert is_adjacent(
                  prev_line: before_line,
                  line: current_line,
                  next_line: next_line,
                  starting: starting,
                  ending: ending)
  end

  def test_extract_numbers
    assert_equal [
                  {number: 467, starting: 0, ending: 2 },
                  {number: 114, starting: 5, ending: 7 }],
                 extract_numbers(@lines[0])
  end

  def test_run_a_line
    before_line = @lines[1]
    current_line = @lines[2]
    next_line = @lines[3]
    assert_equal (35+633), run_a_line(prev_line: before_line, line: current_line, next_line: next_line)
  end

  def test_run_all_lines
    assert_equal 4361, run_all_lines(@lines)
  end

  def test_get_all_neighboring_numbers
    assert_equal [467, 35], get_all_neighboring_numbers(@lines[0], @lines[1], @lines[2], 3)
    assert_equal [], get_all_neighboring_numbers(@lines[1], @lines[2], @lines[3], 0)
    assert_equal [617], get_all_neighboring_numbers(@lines[3], @lines[4], @lines[5], 3)
    assert_equal [755, 598], get_all_neighboring_numbers(@lines[7], @lines[8], @lines[9], 5)
  end

  def test_calculate_all_gear_ratios
    assert_equal 467835, calculate_all_gear_ratios(@lines)
  end

  def test_one_whole_line
    prev_line = "........................617.........123...........341.........................293..................38..19.753..................533.........."
    line = "565.......................-..............951.....+..........354.....697.58....*.....941............*.....*.........+....529....&.....36....."
    next_line = "....1.....225...73...................472.......................-....*......920..999.......646..771.433......407..405.....*.......426*......."
    assert_equal (293*920 + 38*433 + 19*753), process_gears_for_one_line(prev_line, line, next_line)
  end
end