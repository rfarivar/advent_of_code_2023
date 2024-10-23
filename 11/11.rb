class Sky
  attr_accessor :sky, :expanded_sky, :stars, :empty_space_columns, :empty_space_rows, :empty_space_size
  def initialize(filename, empty_space_size = 100)
    @sky = read_file(filename)
    @expanded_sky = []
    @stars = []
    @empty_space_size = empty_space_size
  end

  def read_file(filename)
    File.read(filename).split("\n").map(&:strip).map(&:chars)
  end

  def expand_sky
    sky_transposed = @sky.transpose
    expanded_sky = []
    sky_transposed.each do |col|
      expanded_sky << col.dup
      if col.all?('.')
        expanded_sky << col.dup
      end
    end
    sky = expanded_sky.transpose
    sky.each do |row|
      @expanded_sky << row.dup
      if row.all?('.')
        @expanded_sky << row.dup
      end
    end
  end

  def extract_stars
    expand_sky if @expanded_sky.empty?
    @expanded_sky.each_with_index do |row, row_index|
      row.each_with_index do |value, column_index|
        @stars << {row: row_index, col: column_index} if value == '#'
      end
    end
  end

  def distance(star_1, star_2)
    extract_stars if @stars.empty?
    (star_1[:row] - star_2[:row]).abs + (star_1[:col] - star_2[:col]).abs
  end

  def sum_distances
    extract_stars if @stars.empty?
    sum = 0
    @stars.each do |star_1|
      @stars.each do |star_2|
        if star_1 != star_2
          sum += distance(star_1, star_2)
        end
      end
    end
    sum / 2
  end

  def super_expand_sky
    @empty_space_rows = []
    @sky.each_with_index do |row, i|
      if row.all?('.')
        @empty_space_rows << i
      end
    end

    sky_transposed = @sky.transpose
    @empty_space_columns = []
    sky_transposed.each_with_index do |col, j|
      if col.all?('.')
        @empty_space_columns << j
      end
    end
  end

  def extract_stars_from_super_sky
    super_expand_sky if @empty_space_columns.empty? && @empty_space_rows.empty?
    @sky.each_with_index do |row, row_index|
      row.each_with_index do |value, column_index|
        if value == '#'
          num_empty_rows_before_row = @empty_space_rows.filter{|i| i<row_index}.count
          num_empty_columns_before_column = @empty_space_columns.filter{|j| j<column_index}.count

          @stars << {row: row_index + (@empty_space_size - 1) * num_empty_rows_before_row,
                     col: column_index + (@empty_space_size - 1) * num_empty_columns_before_column}

        end
      end
    end
  end
end

sky = Sky.new("11/input")
sky.super_expand_sky
sky.empty_space_size = 1_000_000
sky.extract_stars_from_super_sky
sum_distances_level_2 = sky.sum_distances
# puts("sum_all_distances: #{sky.sum_distances}")
puts("sum_all_distances for level 2: #{sum_distances_level_2}")
