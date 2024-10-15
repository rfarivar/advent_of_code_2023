class Hand
  attr_accessor :hand_string
  attr_accessor :hand_hash
  attr_accessor :bid

  CARD_RANK = %w(A K Q J T 9 8 7 6 5 4 3 2)

  def initialize(hand_string, bid = 0 )
    @hand_string = hand_string
    @hand_hash = Hash.new(0)
    hand_string.chars.each {|c| @hand_hash[c] += 1}
    @bid = bid.to_i
  end

  def five_of_a_kind?
    hand_hash.keys.size == 1
  end

  def four_of_a_kind?
    hand_hash.keys.size == 2 && hand_hash.values.include?(4) && hand_hash.values.include?(1)
  end

  def full_house?
    hand_hash.keys.size == 2 && hand_hash.values.include?(3) && hand_hash.values.include?(2)
  end

  def three_of_a_kind?
    hand_hash.keys.size == 3 && hand_hash.values.include?(3) && hand_hash.values.include?(1)
  end

  def two_pair?
    hand_hash.keys.size == 3 && hand_hash.values.include?(2) && hand_hash.values.include?(1)
  end

  def one_pair?
    hand_hash.keys.size == 4 && hand_hash.values.include?(2) && hand_hash.values.include?(1)
  end

  def nothing?
    hand_hash.keys.size == 5 && hand_hash.values.include?(1)
  end

  def category_value
    if five_of_a_kind?
      0
    elsif four_of_a_kind?
      1
    elsif full_house?
      2
    elsif three_of_a_kind?
      3
    elsif two_pair?
      4
    elsif one_pair?
      5
    elsif nothing?
      6
    end
  end

  def <=>(other)
    if category_value < other.category_value
      return 1
    elsif category_value > other.category_value
      return -1
    else
      hand_string.chars.each_with_index do |card, i|
        if CARD_RANK.index(card) < CARD_RANK.index(other.hand_string.chars[i])
          return 1
        elsif CARD_RANK.index(card) > CARD_RANK.index(other.hand_string.chars[i])
          return -1
        end
      end
    end
    0
  end
end

def read_hands(filename)
  lines = File.read(filename).split("\n").map(&:strip)
  hands = []
  lines.each do |line|
    hand, bid = line.split
    hands << Hand.new(hand, bid)
  end
  hands
end

def total_winnings(filename)
  hands = read_hands(filename)
  hands_sorted = hands.sort
  total_winnings = 0
  hands_sorted.each_with_index do |hand, i|
    total_winnings += hand.bid * (i+1)
  end
  total_winnings
end

puts "total_winnings: #{total_winnings('7/input')}"