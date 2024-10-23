class Sky
  attr_accessor :sky, :expanded_sky, :stars
  def initialize(filename)
    @sky = read_file(filename)
    @expanded_sky = []
    @stars = []
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
end

sky = Sky.new("11/input")
puts("summ_all_distances: #{sky.sum_distances}")
