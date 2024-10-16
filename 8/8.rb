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

def traverse_network_round_1(map, limit = 100_000)
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
    node = next_node
    counter += 1
    break if counter == limit
  end
  counter
end

# Abanodoned approach
def traverse_network_round_2(map)
  network = map[:network]
  nodes_ending_with_A = network.filter{|m| m =~ /\w\wA/}
  nodes_ending_with_Z = network.filter{|m| m =~ /\w\wZ/}
  nodes_ending_with_A.each_key do |node_string|
    nodes_ending_with_A[node_string][:start_node] = node_string
    nodes_ending_with_A[node_string][:current_node] = node_string
    nodes_ending_with_A[node_string][:cycle_count] = 0
    nodes_ending_with_A[node_string][:cycle_complete] = false
  end
  counter = 0
  nodes = nodes_ending_with_A.values
  destination = nodes_ending_with_Z
  instructions_list = map[:instructions].chars

  until all_cycles_complete?(nodes)
    # Node structure example: {:L=>"THS", :R=>"NKH", :start_position=>"GSA", :current_node=>"GSA", :cycle_count=>0, :cycle_complete=>false}
    if instructions_list.empty?
      instructions_list = map[:instructions].chars
    end
    instruction = instructions_list.shift
    next_nodes = {}
    nodes.each_key do |node_string|
      next_node_string = instruction == 'L' ? network[node_string][:L] : network[node_string][:R]
      next_nodes[next_node_string] = network[next_node_string]
    end
    p counter if counter % 1_000_000 == 0
    nodes = next_nodes
    counter += 1
  end
  counter
end

# abandoned helper function for the abandoned traverse_network_round_2
def all_cycles_complete?(nodes)
  nodes.all? do |node|
    node[:start_node] == node[:current_node] && node[:cycle_count] > 0
  end
end


map = read_file("8/input")
network = map[:network]
nodes_ending_with_A = network.filter{|m| m =~ /\w\wA/}.keys
nodes_ending_with_Z = network.filter{|m| m =~ /\w\wZ/}.keys

answers = []

# A little unoptimized approach. We use the fact that each node_ending_with_A will only ever reach exactly one
# node_ending_with_Z. How do I know this? A. Because it wouldn't work any other way, if the graph can reach more than one
# node_ending_with_Z, it would probably make it too hard?! B, someone else plotted the nodes and found this is true:
# https://www.reddit.com/r/adventofcode/comments/18did3d/2023_day_8_part_1_my_input_maze_plotted_using/#lightbox
#
# Ideally, I should write another traverse_network_round_3, where we start from one of the six nodes_ending_with_A, and
# to stop the cycle check against any of the six nodes_ending_with_Z. But I was lazy, and the function that checks the
# cycles for a specific pair of starting and ending nodes runs fairly fast. So since we only have 36 possibilities, I'm
# doing a small O(n^2) loop here to find which ones reach an answer. The trick is to put a limit on the number of allowed
# cycles (1_000_000) and if we don't reach the end node within this limit, exit. Since the answer to part A (for AAA to ZZZ)
# took only 13_771 cycles, I think 1 million is a fairly safe bet. Running all 36 loops took ~5 seconds on my machine.

limit = 1_000_000
nodes_ending_with_A.each do |node_ending_with_A|
  nodes_ending_with_Z.each do |node_ending_with_Z|
    map[:first_node] = node_ending_with_A
    map[:last_node] = node_ending_with_Z
    a = traverse_network_round_1(map, limit)
    if a != limit
      answers << a
      puts "found a solution for node_ending_with_A: #{node_ending_with_A} and node_ending_with_Z: #{node_ending_with_Z} with #{a} cycles."
    end
  end
end

# Now that we know how many cycles it takes each loop to repeat, we just need to find the
# least common multiplier of them. Luckily, Ruby has an lcm function to find the lcm of two numbers, so we just
# run it on all numbers.
p answers.reduce(1, &:lcm)

# map[:first_node] = "AAA"
# map[:last_node] = "ZZZ"
# p traverse_network_round_1(map)