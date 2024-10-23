require "minitest/autorun"
require_relative "11"

class Test_sky < Minitest::Test
  def setup
    super
    @sky = Sky.new("11/test1")
    @expanded_sky = Sky.new("11/test1_expanded")
  end

  def test_sky_expansion
    @sky.expand_sky
    assert_equal @expanded_sky.sky, @sky.expanded_sky
  end

  def test_extract_stars
    @sky.extract_stars
    expected_stars = [{row: 0, col: 4}, {row: 1, col: 9}, {row:2, col:0},
                      {row: 5, col: 8}, {row: 6, col: 1}, {row: 7, col: 12},
                      {row: 10, col: 9}, {row: 11, col: 0}, {row: 11, col: 5}]
    expected_stars.each do |star|
      assert_includes @sky.stars, star
    end
  end

  def test_distance
    star_1 = {row: 0, col: 4}
    star_2 = {row:10, col:9}
    assert_equal 15, @sky.distance(star_1, star_2)

    star_1 = {row:2, col:0}
    star_2 = {row: 7, col: 12}
    assert_equal 17, @sky.distance(star_1, star_2)

    star_1 = {row: 11, col: 0}
    star_2 = {row: 11, col: 5}
    assert_equal 5, @sky.distance(star_1, star_2)
  end

  def test_all_distances
    assert_equal 374, @sky.sum_distances
  end

  def test_super_expansion
    @sky.super_expand_sky
    assert_equal [3, 7], @sky.empty_space_rows
    assert_equal [2, 5, 8], @sky.empty_space_columns
  end

  def test_extract_stars_from_super_sky
    @sky.super_expand_sky

    @sky.empty_space_size = 2
    @sky.extract_stars_from_super_sky
    sum_distances = @sky.sum_distances
    assert_equal 374, sum_distances

    @sky.empty_space_size = 10
    @sky.stars = []
    @sky.extract_stars_from_super_sky
    sum_distances = @sky.sum_distances
    assert_equal 1030, sum_distances

    @sky.empty_space_size = 100
    @sky.stars = []
    @sky.extract_stars_from_super_sky
    sum_distances = @sky.sum_distances
    assert_equal 8410, sum_distances
  end
end