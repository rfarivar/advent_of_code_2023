class PipeMaze
  attr_accessor :maze
  def initialize(filename)
    load_maze(filename)
  end
  def load_maze(filename)
    @maze = File.read(filename).split("\n").map(&:strip).map(&:chars)
    @maze_num_rows = @maze.size
    @maze_num_cols = @maze[0].size
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
      connected
    else
       []
    end
  end

  def find_loop_length
    loop_length = 0
    start_location = find_start
    next_location = connected_locations(start_location).first
    location = start_location
    while location != start_location  || loop_length <= 0
      previous_location = location
      location = next_location
      connected_locations_to_current = connected_locations(location)
      connected_locations_to_current.delete(previous_location)
      next_location = connected_locations_to_current.first
      loop_length += 1
    end
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
end

maze = PipeMaze.new("10/input")
l = maze.find_loop_length
puts "Maze loop length is #{l}, therefor half-way point is: #{l/2}"