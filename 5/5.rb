#require 'tty-progressbar'

def read_file(filename)
  lines = File.read(filename).split("\n").map(&:strip)
  seeds = lines[0].split(":")[1].split.map(&:to_i)
  lines.shift
  current_mapping = nil
  mappings = []
  lines.each do |line|
    if line == ""
      next
    elsif line.start_with? /\D/
      mappings << current_mapping if current_mapping
      current_mapping = []
    else
      current_mapping << line.split.map(&:to_i)
    end
  end
  # put the final mapping in the result
  mappings << current_mapping if current_mapping
  {seeds: seeds, mappings: mappings}
end

def e2e_mapping(seed, almanac)
  category = almanac[:mappings]
  source = seed
  category.each do |mappings|
    destination = nil
    mappings.each do |mapping|
      destination_mapping = mapping[0]
      source_mapping = mapping[1]
      range = mapping[2]
      if source >= source_mapping && source < source_mapping + range
        destination = source - source_mapping + destination_mapping
      end
    end
    destination = source unless destination
    source = destination
  end
  source
end

def find_mappings_all_seeds_round_1(almanac)
  seeds = almanac[:seeds]
  seeds.map { |seed| e2e_mapping(seed, almanac)}.min
end

def find_mappings_all_seeds_round_2(almanac)
  seeds = almanac[:seeds]
  seeds_with_ranges = []
  (seeds.size / 2).times do |i|
    seeds_with_ranges << {range_begin: seeds[i*2], range_size: seeds[i*2+1]}
  end
  seeds = []

  puts "seeds_with_ranges now has #{seeds_with_ranges.size} elements"
  # bar1 = TTY::ProgressBar.new("Processing [:bar] :percent", total: seeds_with_ranges.size)
  seeds_with_ranges.each do |range|
    #   bar1.advance
    range_array = (range[:range_begin]..range[:range_begin] + range[:range_size]).to_a
    seeds += range_array
  end


  puts "seeds now has #{seeds.size} elements"
  # bar2 = TTY::ProgressBar.new("Processing [:bar] :percent", total: seeds.size)

  results = seeds.map do |seed|
    #    bar2.advance
    a = e2e_mapping(seed, almanac)
    puts "mapping #{seed} ==> #{a}"
    a
  end
  results.min
end

def process_round_1
  almanac = read_file('5/input')
  result = find_mappings_all_seeds_round_1(almanac)
  puts "result for round 1: #{result}"
end

#brute force approach for the second round. This algorithm takes a LOOONG time
# and can only run the test case
def process_round_2
  almanac = read_file('5/test')
  result = find_mappings_all_seeds_round_2(almanac)
  puts "result for round 1: #{result}"
end

def seeds_array_to_ranges(seeds)
  range_array = []
  (seeds.size / 2).times do |i|
    range_array << {start: seeds[i*2], length: seeds[i*2+1]}
  end
  range_array
end

def range_splitter(range, almanac)
  result = []
  # base case
  range_start_mapped = e2e_mapping(range[:start], almanac)
  range_end_mapped = e2e_mapping(range[:start] + range[:length] - 1, almanac)
  if range_end_mapped  == range_start_mapped + range[:length] - 1
    result << {start: range[:start], length: range[:length], mapped: range_start_mapped}
    return result
  end
  #find the first range, and then let recursion take care of the rest
  range_end = find_first_sub_range(range, almanac)
end

def find_first_sub_range(range, almanac)
  target = range.dup
  target[:end] = range[:start] + range[:length] - 1
  # target[:middle] = target[:start] + (target[:end] - target[:start]) / 2
  # Note that target[:middle] is alwyas good to use to assign to start or end, but
  # in the condition functions, it is calculated from start and end and updated. This works
  # because in Ruby functions are pass by reference, so we can assign range[:middle] values inside functions
  # and then use the value outside
  #
  until middle_on_target_range?(target, almanac)
    #special case for ranges of size 2 at the end of a larger range, hence length = 2
    if target[:end] - target[:start] == 1 && middle_inside_target_range?(target, almanac)
      target[:middle] = target[:end]
      break
    end
    if middle_inside_target_range?(target, almanac)
      target[:start] = target[:middle]
    elsif middle_outside_target_range?(target, almanac)
      target[:end] = target[:middle]
    end
  end
  {start: range[:start], end: target[:middle], length: target[:middle] - range[:start] + 1}
end


def calculate_middle_values(range, almanac)
  start_value = range[:start]
  middle_value = range[:start] + (range[:end] - range[:start]) / 2
  range[:middle] = middle_value
  start_to_middle_distance = middle_value - start_value

  start_value_mapped = e2e_mapping(start_value, almanac)
  middle_value_mapped = e2e_mapping(middle_value, almanac)
  start_to_middle_mapped_distance = middle_value_mapped - start_value_mapped

  element_after_middle_mapped = e2e_mapping(middle_value + 1, almanac)
  start_to_element_after_middle_mapped_distance = element_after_middle_mapped - start_value_mapped

  {
    start_to_middle_distance: start_to_middle_distance,
    start_to_middle_mapped_distance: start_to_middle_mapped_distance,
    start_to_element_after_middle_mapped_distance: start_to_element_after_middle_mapped_distance
  }
end

def middle_on_target_range?(range, almanac)
  values = calculate_middle_values(range, almanac)
  values[:start_to_middle_distance] == values[:start_to_middle_mapped_distance] &&
    values[:start_to_middle_distance] + 1 != values[:start_to_element_after_middle_mapped_distance]
end

def middle_inside_target_range?(range, almanac)
  values = calculate_middle_values(range, almanac)
  values[:start_to_middle_distance] == values[:start_to_middle_mapped_distance] &&
    values[:start_to_middle_distance] + 1 == values[:start_to_element_after_middle_mapped_distance]
end

def middle_outside_target_range?(range, almanac)
  values = calculate_middle_values(range, almanac)
  values[:start_to_middle_distance] != values[:start_to_middle_mapped_distance] &&
    values[:start_to_middle_distance] + 1 != values[:start_to_element_after_middle_mapped_distance]
end

def extract_sub_ranges(range, remainder = range, almanac)
  if !remainder || remainder[:start] == range[:end] || remainder[:length] <= 0
    return []
  end
  first_sub_range = find_first_sub_range(remainder, almanac)
  remainder = {start: first_sub_range[:end]+1, length: remainder[:length] - first_sub_range[:length]}
  partial_result = extract_sub_ranges(range, remainder, almanac)
  partial_result << first_sub_range
end

def find_lowest_location_number(almanac)
  seed_ranges = seeds_array_to_ranges(almanac[:seeds])
  all_sub_ranges = seed_ranges.flat_map do |range|
    extract_sub_ranges(range, almanac)
  end
  location_values_for_first_element_of_all_sub_ranges = all_sub_ranges.map do |sub_range|
    e2e_mapping(sub_range[:start], almanac)
  end
  location_values_for_first_element_of_all_sub_ranges.min
end

# This approach takes a total of 0.5 seconds to run the large input, as compared to
# 10+ hours that the brtue force approach took (and didn't finish!)
# Here, we extract the sub_ranges of each range where they map to contingous end-to-end
# location ranges. The first sub_range is found using binary search, and then use recursion
# to find all of sub_ranges. Finally, we flat_map all the subranges and run the e2e function on
# the first element of each subrange. For reference, 10 seed ranges results into
# 149 contigous sub_ranges. The sum total of all subranges would have been 2_398_198_298
def process_round_2_using_log_n_approach
  almanac = read_file('5/input')
  result = find_lowest_location_number(almanac)
  puts "result for round 1: #{result}"
end

process_round_1
process_round_2_using_log_n_approach
