require "minitest/autorun"
require_relative "8"

class Test8 < Minitest::Test
  def setup
    super
    @test1_map = read_file("8/test")
    @test2_map = read_file("8/test_2")
  end

  def test_read_file
    expected_network = {"AAA" => {L: "BBB", R:"BBB"},
                     "BBB" => {L: "AAA", R:"ZZZ"},
                     "ZZZ" => {L: "ZZZ", R:"ZZZ"}
    }
    expected_instructions = "LLR"
    expected_map = {network: expected_network,
                       instructions: expected_instructions,
                       first_node: "AAA",
                       last_node: "ZZZ"
    }
    assert_equal expected_map, read_file("8/test_2")
  end

  def test_traverse_network
    assert_equal 2, traverse_network(@test1_map)
    assert_equal 6, traverse_network(@test2_map)
  end
end