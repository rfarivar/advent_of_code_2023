def extract_colors_from_line (line, games)
  original_line = line.dup
  match = line.match /Game (?<game_round>\d+):\s(?<rest>.*)/
  game_round = match[:game_round]
  line = match[:rest]
  tries = []
  colors = {}
  match = line.scan /(?<count>\d+) (?<color>\w+)(?<sep>[,;]?)/
  match.each do |m|
    count = m[0]
    color = m[1]
    sep = m[2]
    colors[color.to_sym] = count.to_i
    if sep == ';' || sep == ""
      tries << colors
      colors = {}
    end
  end
  games << {:round_number => game_round.to_i, :tries => tries, :num_tries => tries.count, :original_line => original_line}
end

def read_input
  # Read the input and put in an array
  File.read('/Users/reza/dev/advent/2/input').split("\n")
end

def process_input (input, games)
  input.each do |line|
    extract_colors_from_line(line, games)
  end
end

def is_round_valid? (round, bag_contents)
  round[:tries].each do |try|
    if (try[:green]&.>bag_contents[:green]) ||
      (try[:blue]&.>bag_contents[:blue]) ||
      (try[:red]&.> bag_contents[:red])
      return false
    end
  end
  true
end

def sum_ids_possible_games(games, bag_contents)
  sum = 0
  games.each do |round|
    if is_round_valid?(round, bag_contents)
      sum += round[:round_number]
    end
  end
  sum
end

def find_fewest_number_of_cubes_of_each_color_for_all_rounds(games)
  sum_power = 0
  games.each do |round|
    colors = find_fewest_number_of_cubes_of_each_color_for_one_rounds(round)
    sum_power += colors[:red] * colors[:green] * colors[:blue]
  end
  sum_power
end

def find_fewest_number_of_cubes_of_each_color_for_one_rounds(round)
  red = blue = green = 0
  round[:tries].each do |try|
    green = [(try[:green] || 0), green].max
    blue = [(try[:blue] || 0), blue].max
    red = [(try[:red] || 0), red].max
  end
  {red: red, green: green, blue: blue}
end


def main
  games = []
  bag_contents = {red: 12, green: 13, blue: 14}
  input = read_input
  process_input(input, games)
  puts "sum of ids of possible games = #{sum_ids_possible_games(games, bag_contents)}"
  puts "sum of powers of all rounds = #{find_fewest_number_of_cubes_of_each_color_for_all_rounds(games)}"
end

main