def read_input
  File.read('/Users/reza/dev/advent/3/input').split("\n").map(&:strip)
end

def is_adjacent(prev_line:, line:, next_line:, starting:, ending:)
  candidate_start = [0, starting-1].max
  candidate_end = [ending+1, line.length].min

  prev_region = prev_line ? prev_line[candidate_start .. candidate_end] : ""
  current_region = line[candidate_start .. candidate_end]
  next_region = next_line ? next_line[candidate_start .. candidate_end] : ""

  before =  prev_region =~ /[^\d.]/
  current = current_region =~ /[^\d.]/
  after =  next_region =~ /[^\d.]/

  before || current || after
end

def extract_numbers (line)
  numbers = []
  line.scan /(\d+)/ do
    match_data = Regexp.last_match
    numbers << {number: match_data[0].to_i, starting: match_data.begin(0), ending: match_data.end(0)-1 }
  end
  numbers
end

# line is guaranteed to have a non-nil value, but the other two can be nil
def run_a_line (prev_line:, line:, next_line:)
  numbers = extract_numbers(line)
  sum = 0
  numbers.each do |number|
    if is_adjacent(prev_line: prev_line, line: line, next_line:next_line, starting: number[:starting], ending: number[:ending])
      sum += number[:number]
    end
  end
  sum
end

def run_all_lines (lines)
  sum = 0
  lines.each_with_index do |line, index|
    prev_line = lines[index-1] if index > 0
    next_line = lines[index+1] if index < lines.size
    sum += run_a_line(prev_line: prev_line, line: line, next_line: next_line)
  end
  sum
end

def read_input_and_run_all_lines
  lines = read_input
  run_all_lines lines
end

def get_all_neighboring_numbers(prev_line, line, next_line, star_location)
  result = []

  beginning = [star_location - 3, 0].max
  ending = [star_location + 3, line.size].min

  same_line_left = line[beginning..ending].match /(\d{1,3})\*/
  same_line_right = line[beginning..ending].match /\*(\d{1,3})/
  result << same_line_left[1].to_i if same_line_left
  result << same_line_right[1].to_i if same_line_right

  prev_line[beginning..ending].scan /(\d{1,3})/ do
    match =  Regexp.last_match
    result << match[1].to_i if star_location - beginning >= (match.begin(1) - 1) && star_location - beginning <= (match.end(1))
  end

  next_line[beginning..ending].scan /(\d{1,3})/ do
    match = Regexp.last_match
    result << match[1].to_i if star_location - beginning >= (match.begin(1) - 1) && star_location - beginning <= (match.end(1))
  end
  result
end

def process_gears_for_one_line(prev_line, line, next_line)
  sum = 0
  line.scan /\*/ do
    match = Regexp.last_match
    numbers = get_all_neighboring_numbers( prev_line, line, next_line, match.begin(0))
    sum += numbers.reduce(&:*) if numbers.size == 2
  end
  sum
end

def calculate_all_gear_ratios(lines)
  sum = 0
  lines.each_with_index do |line, index|
    prev_line = lines[index-1] if index > 0
    next_line = lines[index+1] if index < lines.size
    sum += process_gears_for_one_line(prev_line, line, next_line)
  end
  sum
end

def read_input_and_calculate_all_gear_ratios
  lines = read_input
  calculate_all_gear_ratios lines
end

puts "read_input_and_run_all_lines = #{read_input_and_run_all_lines}"
puts "read_input_and_calculate_all_gear_ratios = #{read_input_and_calculate_all_gear_ratios}"
