def read_file(filename)
  lines = File.read(filename).split("\n").map(&:strip).map(&:split)
  lines.map{|sequence| sequence.map(&:to_i)}
end

def difference_sequence (sequence)
  sequence.each_cons(2).to_a.map{|a,b| b-a}
end

def all_sequences (sequence)
  all_sequences = [sequence]
  until all_sequences.last.all?(0)
    all_sequences << difference_sequence(all_sequences.last)
  end
  all_sequences
end

def extrapolate_last_digit (sequence)
  all_sequences = all_sequences(sequence)
  all_sequences.reverse!
  element_to_add = 0
  until all_sequences.empty?
    seq = all_sequences.shift
    element_to_add += seq.last
  end
  element_to_add
end

def extrapolate_first_digit (sequence)
  all_sequences = all_sequences(sequence)
  all_sequences.reverse!
  element_to_subtract = 0
  until all_sequences.empty?
    seq = all_sequences.shift.reverse
    element_to_subtract = seq.last - element_to_subtract
  end
  element_to_subtract
end

def sum_last_digit_extrapolation_for_all_inputs(filename)
  reports = read_file(filename)
  reports.map {|report| extrapolate_last_digit(report)}.sum
end


def sum_first_digit_extrapolation_for_all_inputs(filename)
  reports = read_file(filename)
  reports.map {|report| extrapolate_first_digit(report)}.sum
end


reports = sum_last_digit_extrapolation_for_all_inputs("9/input")
puts "sum_all_inputs_part_1: #{reports}"

reports = sum_first_digit_extrapolation_for_all_inputs("9/input")
puts "sum_all_inputs_part_2: #{reports}"