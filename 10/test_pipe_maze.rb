require "minitest/autorun"
require_relative "pipe_maze"

class TestPipeMaze < Minitest::Test
  def setup
    super
    @test_maze_1 = PipeMaze.new("10/test1")
    @test_maze_2 = PipeMaze.new("10/test2")
    @test_maze_3 = PipeMaze.new("10/test3")

    @test_maze_4 = PipeMaze.new("10/test4")
    @test_maze_5 = PipeMaze.new("10/test5")
    @test_maze_6 = PipeMaze.new("10/test6")
    @test_maze_7 = PipeMaze.new("10/test7")
  end

  def test_load_maze
    expected_maze = [%w(. . . . .),
                     %w(. S - 7 .),
                     %w(. | . | .),
                     %w(. L - J .),
                     %w(. . . . .)]
    assert_equal expected_maze, @test_maze_1.maze
  end

  def test_connected_cell
    expected_cells = [[2, 1], [3, 2]]
    actual_cells = @test_maze_1.connected_locations([3, 1])
    assert_equal expected_cells, actual_cells

    start_location = @test_maze_1.find_start
    expected_cells = [[2, 1], [1, 2]]
    actual_cells = @test_maze_1.connected_locations(start_location)
    assert_equal expected_cells, actual_cells
  end

  def find_start
    assert_equal [1,1], @test_maze_1.find_start
  end

  def test_find_loop_length
    assert_equal 8, @test_maze_1.find_loop_length
    assert_equal 8, @test_maze_2.find_loop_length
    assert_equal 16, @test_maze_3.find_loop_length
  end
  def arrays_different? (a,b)
    a.difference(b).any? || b.difference(a).any?
  end

  def test_count_vertical_borders
    row_above = @test_maze_4.maze[5]
    row_below = @test_maze_4.maze[6]
    # .|L-7.F-J|.
    # .|..|.|..|.
    expected_before = [0, 0, 1, 1, 1, 2, 2, 3, 3, 3, 4]
    expected_after =  [4, 3, 3, 3, 2, 2, 1, 1, 1, 0, 0]
    (0..10).each do |i|
      assert_equal expected_before[i], @test_maze_4.count_vertical_borders(5, i, :before), "index: #{i}"
      assert_equal expected_after[i], @test_maze_4.count_vertical_borders(6, i, :after), "index: #{i}"
    end
  end

  def test_count_inside
    assert_equal 4, @test_maze_4.count_inside_for_one_row(6)
  end

  def test_count_all_inside
    assert_equal 4, @test_maze_4.count_all_inside
    assert_equal 4, @test_maze_5.count_all_inside
    assert_equal 8, @test_maze_6.count_all_inside
    assert_equal 10, @test_maze_7.count_all_inside

  end
end