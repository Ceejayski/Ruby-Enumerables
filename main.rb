module Enumerable
  def my_each
    return to_enum unless block_given?

    array = to_a
    index = 0
    while index < size
      yield(array[index])
      index += 1
    end
    array
  end

  #--------my each by index -------
  def my_each_with_index
    return to_enum unless block_given?

    array = to_a
    index = 0
    while index < size
      yield(array[index], index)
      index += 1
    end
    array
  end

  def my_select
    return to_enum unless block_given?

    select = []
    my_each { |i| select.push(i) if yield(i) }
    select
  end

  def my_all?(args = nil)
    if !args.nil? # if arguments or method parameters were given
      case args
      when Class
        my_each { |i| return false unless i.is_a?(args) }
      when Regexp
        my_each { |i| return false unless args.match(i.to_s) }
      else
        my_each { |i| return false unless i == args }
      end
    elsif block_given? # if block was given
      my_each { |i| false unless yield(i) }
    else
      my_each { |i| false unless i }
    end
    true
  end

  def my_any?(args = nil)
    if !args.nil? # if arguments or method parameters were given
      case args
      when Class
        my_each { |i| return true if i.is_a?(args) }
      when Regexp
        my_each { |i| return true if args.match(i.to_s) }
      else
        my_each { |i| return true if i == args }
      end
    elsif block_given? # if block was given
      my_each { |i| true if yield(i) }
    else
      my_each { |i| true if i }
    end
    false
  end

  def my_none?(args = nil)
    if !args.nil? # if arguments or method parameters were given
      case args
      when Class 
        my_each { |i| return false if i.is_a?(args) }
      when Regexp
        my_each { |i| return false if args.match(i.to_s) }
      else
        my_each { |i| return false if i == args }
      end
    elsif block_given? # if block was given
      my_each { |i| false if yield(i) }
    else
      my_each { |i| false if i }
    end
    true
  end

  def my_count(args = nil)
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

  def my_inject(arg1 = nil, arg2 = nil)
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
