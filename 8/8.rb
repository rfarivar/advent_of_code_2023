def read_file(filename)
  lines = File.read(filename).split("\n").map(&:strip)
  instructions = lines[0]
  network = {}
  lines = lines.drop(2)
  first_node = nil
  last_node = nil
  lines.each_with_index do |line, i|
    m = line.match /(?<source>\w{3}) = \((?<left>\w{3}), (?<right>\w{3})\)/
    network[m[:source]] = {L: m[:left], R: m[:right]}
    if i == 0
      first_node = m[:source]
    elsif i == lines.size - 1
      last_node = m[:source]
    end
  end
  {instructions: instructions, network: network, first_node:first_node, last_node:last_node }
end

def traverse_network(map)
  counter = 0
  node = map[:first_node]
  destination = map[:last_node]
  instructions_list = map[:instructions].chars
  network = map[:network]

  until node == destination
    if instructions_list.empty?
      instructions_list = map[:instructions].chars
    end
    instruction = instructions_list.shift
    next_node = instruction == 'L' ? network[node][:L] : network[node][:R]
    puts "counter in millions: #{counter/1_000_000}m" if counter % 1_000_000 == 8
    node = next_node
    counter += 1
  end
  counter
end

map = read_file("8/input")
map[:first_node] = "AAA"
map[:last_node] = "ZZZ"
p traverse_network(map)