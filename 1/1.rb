NUMBERS_STRING = %w(zero one two three four five six seven eight nine)
NUMBERS = %w(0 1 2 3 4 5 6 7 8 9)
NUMBERS_HASH = Hash[NUMBERS_STRING.zip(NUMBERS)]
RE = /(zero|one|two|three|four|five|six|seven|eight|nine)/

def replace_text_with_numbers (line)
  match = 1
  while match
    match = line.match(RE)
    if match
      line[match.begin(1)+1,match[1].length-2] = NUMBERS_HASH[match[1]]
    end
  end
  line
end

# def replace_text_with_numbers (line)
#   local_line = line
#   NUMBERS_STRING.each_with_index { |number, index| local_line = local_line.gsub number, index.to_s }
#   local_line
# end

def read_input
  # Read the input and put in an array
  File.read('input').split("\n")
end

def process_one_line(line)
  lino = replace_text_with_numbers(line.dup)
  arr = lino.chars.select { |x| x =~ /\d/ }
  first_digit = arr.first.to_i
  second_digit = arr.last.to_i
  first_digit * 10 + second_digit
end

def process_one_line_re(line)
  lino = replace_text_with_numbers(line.dup)
  first_digit = lino.match(/\d/)[0]
  second_digit = lino.reverse.match(/\d/)[0]
  (first_digit + second_digit).to_i
end

def process_input(input)
  input.map {|line| process_one_line_re(line)}.sum
end

def main
  input = read_input
  result = process_input(input)
  puts result
end

main
