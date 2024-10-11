def read_card (card)
  match = card.match /Card\s+(?<card_number>\d+):(?<winning>.*)\|(?<have>.*)$/
  {winning_numbers: match[:winning].split.map(&:to_i),
   have_numbers: match[:have].split.map(&:to_i),
   card_number: match[:card_number].to_i}
end

# Given a card hash, returns the card_points for part 1
def card_points (card)
  have_numbers = card[:have_numbers]
  winning_numbers = card[:winning_numbers]
  matching_numbers = winning_numbers.select { |number| have_numbers.include? number}
  matching_numbers.size > 0 ? 2 ** (matching_numbers.size - 1) : 0
end

def card_matches(card)
  have_numbers = card[:have_numbers]
  winning_numbers = card[:winning_numbers]
  winning_numbers.select { |number| have_numbers.include? number}.size
end

def read_all_lines
  File.read("4/input").split("\n").map(&:strip)
end

def calculate_total_points_round_1 (lines)
  cards = lines.map {|line| read_card(line)}
  cards.reduce(0) { |sum, card| sum + card_points(card)}
end

def process_round_2 (lines)
  original_cards = lines.map {|line| read_card(line)}
  playing_deck = lines.map {|line| read_card(line)}
  playing_deck.each do |card|
    card_number = card[:card_number]
    card_matches = card_matches(card)
    card_matches.times do |i|
      playing_deck << original_cards[card_number-1 + i+1]
    end
  end
  playing_deck.size
end

def main_round_1
  lines = read_all_lines
  sum = calculate_total_points_round_1 lines
  puts "calculate_total_points result for round 1: #{sum}"
end

def main_round_2
  lines = read_all_lines
  result = process_round_2(lines)
  puts "result for round 2: #{result}"
end

main_round_1
main_round_2
