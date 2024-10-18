require "minitest/autorun"
require_relative "pipe_maze"

class TestPipeMaze < Minitest::Test
  def setup
    super
    @test_maze_1 = PipeMaze.new("10/test1")
    @test_maze_2 = PipeMaze.new("10/test2")
    @test_maze_3 = PipeMaze.new("10/test3")
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

end