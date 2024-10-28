class HotSprings
  attr_accessor :spring_rows
  def initialize(filename)
    read_file(filename)
  end

  def read_file(filename)
    @spring_rows = []
    spring_rows = File.read(filename).split("\n").map(&:strip)
    spring_rows.map do |row|
      row_string, groups = row.split
      groups = groups.split(",").map(&:to_i)
      @spring_rows << [row_string, groups]
    end
  end
  def count_possible(row_index)
    row_string, groups = @spring_rows[row_index]
    count_recursive(row_string, '.', groups)
  end

  def count_recursive(row_string, preceding_char, input_groups)
    # p("#{preceding_char + row_string}", input_groups)
    groups = input_groups.dup
    if row_string.empty? && (groups.empty? || (groups.size == 1 && groups.first == 0))
      return 1
    elsif row_string.empty? && (!groups.empty? ) # && groups.first != 0
      return 0
    end

    first_char = row_string[0]
    if first_char == '.'
      if preceding_char == '#' && groups.first != 0
        # We have a #. means a sequence has come to an end.
        # We should check to see if it has used up all the group budget. if not, we have an error
        # condition, which means a bad choice was made previously
        return 0
      elsif preceding_char == '#' && groups.first == 0
        # We have a #. means a sequence has come to an end, and the budget has also finished.
        # We're good to continue
        groups.shift(1)
        return count_recursive(row_string[1..], '.' , groups)
      elsif preceding_char == '.'
        # we have a .. just continue
        return count_recursive(row_string[1..], '.' , groups)
      end
    elsif first_char == '#'
      if preceding_char == '#' && groups.first == 0
        # We have a ## means we are in a continuing sequence
        # We should check to see if it has used up all the group budget. if so, we have an error
        # condition, which means a bad choice was made previously
        return 0
      elsif preceding_char == '#' && groups.first > 0
        # We have a ## means we are in a continuing sequence, and we still have budget for the
        # first_char to be #. We're good to continue
        groups[0] -= 1
        return count_recursive(row_string[1..], '#' , groups)
      elsif preceding_char == '.' && (groups.first == 0 || groups.empty?)
        # we have a .# which is the beginning of a sequence. But if we don't have a budget, it was an error
        return 0
      elsif preceding_char == '.' && groups.first > 0
        # we have a .# which is the beginning of a sequence, and have the budget, so we're good to continue.
        groups[0] -= 1
        return count_recursive(row_string[1..], '#' , groups)
      end
    elsif first_char == '?'
      if preceding_char == '#' && groups.first == 0
        # we have #?  and we had spent all the # budget before, so the sequence of # has come to an end
        # therefore ? should be a .
        groups.shift(1)
        return count_recursive(row_string[1..], '.',  groups)
      elsif preceding_char == '#' && groups.first > 0
        # we have #?  and we still have budget for # so this character has to be a # as well.
        groups[0] -= 1
        return count_recursive(row_string[1..], '#',  groups)
      elsif preceding_char == '.' && (groups.empty? || groups.first == 0)
        # we have .? but the budget for first group shows 0 (or there is no budget as it was legitimately used before).
        count_recursive(row_string[1..], '.',  groups)
        # return 0
      elsif preceding_char == '.' && groups.first > 0
        # we have .? and also have budget to make this ? a .#  But we could also choose to make it a ..
        a = count_recursive(row_string[1..], '.',  groups)
        groups[0] -= 1
        b = count_recursive(row_string[1..], '#',  groups)
        return a + b
      end
    end
  end

  def sum_all_counts
    sum = 0
    @spring_rows.count.times do |i|
      count_for_row = count_possible(i)
      sum += count_for_row
      puts "count for row #{i} is #{count_for_row}"
    end
    sum
  end
end

springs = HotSprings.new("12/input")
puts "sum of all counts = #{springs.sum_all_counts}"


