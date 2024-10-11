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

def find_e2e_mapping(seed, almanac)
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

def find_mappings_all_seeds(almanac)
  seeds = almanac[:seeds]
  seeds.map { |seed| find_e2e_mapping(seed, almanac)}.min
end

def process_round_1
  almanac = read_file('5/input')
  result = find_mappings_all_seeds(almanac)
  puts "result for round 1: #{result}"
end

process_round_1
