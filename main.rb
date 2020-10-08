module Enumerable
  def my_each(*)
    return to_enum unless block_given?

    range = self
    range_check = true if is_a?(Range)
    array = to_a
    index = 0
    while index < size
      yield(array[index])
      index += 1
    end
    return range if range_check == true

    array
  end

  #--------my each by index -------
  def my_each_with_index(*)
    return to_enum unless block_given?

    range = self
    range_check = true if is_a?(Range)
    array = to_a
    index = 0
    while index < size
      yield(array[index], index)
      index += 1
    end
    return range if range_check == true

    array
  end

  def my_select(*)
    return to_enum unless block_given?

    select = []
    my_each { |i| select.push(i) if yield(i) }
    select
  end

  def my_all?(args = nil, *)
    if block_given?
      my_each { |x| return false unless yield(x) }
    elsif !args.nil?
      case args
      when Class
        my_each { |x| return false unless x.is_a?(args) }
      when Regexp
        my_each { |x| return false unless args.match(x.to_s) }
      else
        my_each { |x| return false unless x == args }
      end
    else
      my_each { |x| return false unless x }
    end
    true
  end

  def my_any?(args = nil, *)
    if block_given?
      my_each { |x| return true if yield(x) }
    elsif !args.nil?
      case args
      when Class
        my_each { |x| return true if x.is_a?(args) }
      when Regexp
        my_each { |x| return true if args.match(x.to_s) }
      else
        my_each { |x| return true if x == args }
      end
    else
      my_each { |x| return true if x }
    end
    false
  end

  def my_none?(args = nil, *)
    if block_given?
      my_each { |x| return false if yield(x) }
    elsif !args.nil?
      case args
      when Class
        my_each { |x| return false if x.is_a?(args) }
      when Regexp
        my_each { |x| return false if args.match(x.to_s) }
      else
        my_each { |x| return false if x == args }
      end
    else
      my_each { |x| return false if x }
    end
    true
  end

  def my_count(args = nil, *)
    total = 0
    if block_given? # block was stated and args is nil
      my_each { |i| total += 1 if yield(i) }
    elsif !args.nil? # block wasn't stated and args isnot nil
      my_each { |i| total += 1 if i == args }
    else
      return size
    end
    total
  end

  def my_map(args = nil, &block)
    return to_enum(:my_map) if args.nil? && !block_given?

    mapped = []
    if args.nil? # if block was given
      my_each { |i| mapped << block.call(i) }
    else # if proc was given
      my_each { |i| mapped << args.call(i) }
    end
    mapped
  end

  def my_inject(arg1 = nil, arg2 = nil, *)
    if block_given?
      initial = arg1
      my_each { |item| initial = initial.nil? ? item : yield(initial, item) }
      initial
    elsif arg1.is_a?(Symbol) || arg1.is_a?(String)
      initial = nil
      my_each { |item| initial = initial.nil? ? item : initial.send(arg1, item) }
      initial
    elsif arg2.is_a?(Symbol) || arg2.is_a?(String)
      initial = arg1
      my_each { |item| initial = initial.nil? ? item : initial.send(arg2, item) }
      initial
    else
      raise LocalJumpError, 'No block Given or Empty Argument' unless !arg1.nil? && !arg2.nil? && !block_given?
    end
  end
end

def multiply_els(arr)
  arr.my_inject(1) { |multiple, i| multiple * i }
end

[1, 2, 3, 4, 5].my_each { |x| puts x }

[1, 2, 3, 4, 5].my_each_with_index { |x, y| puts "#{x} and #{y}" }

[1, 2, 3, 4, 5].my_select { |x| puts x if x.even? }

puts [1, 2, 3, 4, 5].my_all?(Integer)

puts [1, 2, 3, 4, 5].my_any?(Integer)

puts [1, 2, 3, 4, 5].my_none?(/d/)

puts [1, 2, 3, 4, 5, 3, 3, 3, 3, 3, 3].my_count

puts

print [1, 2, 3, 4, 5, 3, 3, 3, 3, 3, 3].my_inject(:+)

true_array = [nil, false, true, []]

puts true_array.my_any?

my_proc = proc { |x| puts x }

[1, 2, 3, 4, 5, 3, 3, 3, 3, 3, 3].my_each(&my_proc)
