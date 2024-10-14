def read_races_round_1(filename)
  lines = File.read(filename).split("\n").map(&:strip)
  times = lines[0].scan /\d+/
  distances = lines[1].scan /\d+/
  times.zip(distances).map {|x|{time:x[0].to_i, distance:x[1].to_i}}
end

def read_races_round_2(filename)
  lines = File.read(filename).split("\n").map(&:strip)
  times = lines[0].scan /\d+/
  distances = lines[1].scan /\d+/
  time = times.join
  distance = distances.join
  {time:time.to_i, distance:distance.to_i}
end

def calculate_winning_range_for_one_race(race)
  delta = 0.0000000001
  race[:time] -= delta
  root_1 = (race[:time] - Math.sqrt((race[:time]**2 - 4*race[:distance])))/2
  root_2 = (race[:time] + Math.sqrt((race[:time]**2 - 4*race[:distance])))/2
  Range.new(root_1.ceil, root_2.floor).to_a.sort
end

def number_of_ways_to_beat_record_round_1(filename)
  races = read_races_round_1(filename)
  numbers = races.map {|race| calculate_winning_range_for_one_race(race).size}
  numbers.reduce(1, &:*)
end


def number_of_ways_to_beat_record_round_2(filename)
  race = read_races_round_2(filename)
  numbers = calculate_winning_range_for_one_race(race)
  numbers.size
end

puts "number_of_ways_to_beat_record_round_1: #{number_of_ways_to_beat_record_round_1('6/input')}"
puts "number_of_ways_to_beat_record_round_2: #{number_of_ways_to_beat_record_round_2('6/input')}"