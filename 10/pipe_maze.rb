class PipeMaze
  attr_accessor :maze
  def initialize(filename)
    load_maze(filename)
  end
  def load_maze(filename)
    @maze = File.read(filename).split("\n").map(&:strip).map(&:chars)
    @maze_num_rows = @maze.size
    @maze_num_cols = @maze[0].size
    @maze_pipes = []
    maze_pipes_row = [false] * @maze_num_cols
    @maze_num_rows.times {@maze_pipes << maze_pipes_row.dup}
    @maze_borders_found = false
  end

  def maze_at(location)
    row, col = location
    @maze[row][col]
  end

  def connected_locations(location)
    row, col = location
    prev_row = [0, row - 1].max
    prev_col = [0, col - 1].max
    next_row = [row + 1, @maze_num_rows - 1].min
    next_col = [col + 1, @maze_num_cols - 1].min
    north = [prev_row, col]
    south = [next_row, col]
    east = [row, next_col]
    west = [row, prev_col]
    case @maze[row][col]
    when '|'
      [north, south]
    when '-'
      [east, west]
    when 'L'
      [north, east]
    when 'J'
      [north, west]
    when '7'
      [south, west]
    when 'F'
      [south, east]
    when 'S'
      connected = []
      connected << north if ['|', '7', 'F'].include?(maze_at(north))
      connected << south if ['|', 'L', 'J'].include?(maze_at(south))
      connected << east if ['-', '7', 'J'].include?(maze_at(east))
      connected << west if ['-', 'L', 'F'].include?(maze_at(west))
      replace_s_with_real_character(connected, north, south, east, west, row, col)
      connected
    else
       []
    end
  end

  def replace_s_with_real_character(connected, north, south, east, west, row, col)
    if connected.include?(north) && connected.include?(south)
      @maze[row][col] = '|'
    elsif connected.include?(north) && connected.include?(east)
      @maze[row][col] = 'L'
    elsif connected.include?(north) && connected.include?(west)
      @maze[row][col] = 'J'
    elsif connected.include?(south) && connected.include?(east)
      @maze[row][col] = 'F'
    elsif connected.include?(south) && connected.include?(west)
      @maze[row][col] = '7'
    elsif connected.include?(east) && connected.include?(west)
      @maze[row][col] = '-'
    end
  end

  def find_loop_length
    loop_length = 0
    start_location = find_start
    next_location = connected_locations(start_location).first
    location = start_location
    while location != start_location  || loop_length <= 0
      set_maze_pipes(location)
      previous_location = location
      location = next_location
      connected_locations_to_current = connected_locations(location)
      connected_locations_to_current.delete(previous_location)
      next_location = connected_locations_to_current.first
      loop_length += 1
    end
    @maze_borders_found = true
    loop_length
  end

  def find_start
    @maze.each_with_index do |row, row_index|
      row.each_index do |col_index|
        if @maze[row_index][col_index] == 'S'
          return [row_index, col_index]
        end
      end
    end
    []
  end

  def set_maze_pipes(location)
    row, col = location
    @maze_pipes[row][col] = true
  end

  def maze_pipe?(location)
    row, col = location
    @maze_pipes[row][col]
  end

  def count_vertical_borders(row_above_index, column, before_or_after)
    find_loop_length unless @maze_borders_found
    columns = @maze[0].size

    if before_or_after == :before
      beginning_column = 0
      ending_column = [0, column - 1].max
    else
      beginning_column = [columns - 1, column + 1].min
      ending_column = columns-1
    end
    count_vertical_borders = 0
    (beginning_column..ending_column).each do |i|
      a = @maze[row_above_index][i]
      # Note that the ----- borders in the same row can be ignored in counting the vertical borders.
      if @maze_pipes[row_above_index][i] && (%w(F | 7).include? a)
        count_vertical_borders += 1
      end
    end
    count_vertical_borders
  end

  def count_inside_for_one_row(row_index)
    find_loop_length unless @maze_borders_found
    columns = @maze[0].size
    row = row_index

    inside = 0
    (1...columns-1).each do |col|
      unless @maze_pipes[row][col] # only count if false, aka not a border cell
        vertical_borders_before = count_vertical_borders(row, col, :before)
        vertical_borders_after = count_vertical_borders(row, col, :after)
        if [vertical_borders_before.odd?, vertical_borders_after.odd?].all?
          inside += 1
        end
      end
    end
    inside
  end

  def count_all_inside
    inside = 0
    (1...@maze_num_rows - 1).each do |row|
      inside += count_inside_for_one_row(row)
    end
    inside
  end
end

maze = PipeMaze.new("10/input")
loop_length = maze.find_loop_length
puts "Maze loop length is #{loop_length}, therefor half-way point is: #{loop_length/2}"

# The main insight for part 2 is that for any point that is inside the contour, the number of
# vertical borders before and after that point in the same row are odd. This would also be true for
# horizontal borders above and below, but checking that is unnecessary.
count_all_inside = maze.count_all_inside
puts "Maze has #{count_all_inside} locations inside"
