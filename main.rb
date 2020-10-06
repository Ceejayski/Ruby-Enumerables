module Enumerable
  def my_each
    return to_enum unless block_given?

    (0..size - 1).each do |index|
      yield(self[index])
    end
    self
  end

  #--------my each by index -------
  def my_each_with_index
    return to_enum unless block_given?

    (0..size - 1).each do |index|
      yield(self[index], index)
    end
    self
  end

  def my_select
    return to_enum unless block_given?

    select = []
    my_each { |x| select.push(x) if yield(x) }
    select
  end

  def my_all?(args = nil)
    if !args.nil? # if arguments or method parameters were given
      if args.is_a?(Class)
        my_each { |i| return false unless i.is_a?(args) }
      elsif args.is_a?(Regexp)
        my_each { |i| return false unless arg.match(i.to_s) }
      else
        my_each { |i| return false unless i == args }
      end
    elsif block_given? # if block was given
      my_each { |_i| false unless yield(x) }
    else
      my_each { |i| false unless i }
    end
    true
  end

  def my_any?(args = nil)
    if !args.nil? # if arguments or method parameters were given
      if args.is_a?(Class)
        my_each { |i| return true if i.is_a?(args) }
      elsif args.is_a?(Regexp)
        my_each { |i| return true if arg.match(i.to_s) }
      else
        my_each { |i| return true if i == args }
      end
    elsif block_given? # if block was given
      my_each { |_i| true if yield(x) }
    else
      my_each { |i| true if i }
    end
    false
  end

  def my_none?(args = nil)
    if !args.nil? # if arguments or method parameters were given
      if args.is_a?(Class)
        my_each { |i| return false if i.is_a?(args) }
      elsif args.is_a?(Regexp)
        my_each { |i| return false if arg.match(i.to_s) }
      else
        my_each { |i| return false if i == args }
      end
    elsif block_given? # if block was given
      my_each { |_i| false if yield(x) }
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

  def my_map(&block)
    return to_enum(:my_map) unless block_given?

    mapped = []
    my_each { |i| mapped << block.call(i) }
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

def multiply_els(array)
  array.my_inject(1) { |multiple, i| multiple * i }
end

[1, 2, 3, 4, 5].my_each { |x| puts x}

[1, 2, 3, 4, 5].my_each_with_index { |x, y| puts "#{x} and #{y}"}

[1, 2, 3, 4, 5].my_select { |x| puts x if x.even? }

puts [1, 2, 3, 4, 5].my_all?(Integer)

puts [1, 2, 3, 4, 5].my_any?(Integer)

puts [1, 2, 3, 4, 5].my_none?(Integer)

puts [1, 2, 3, 4, 5, 3, 3, 3, 3, 3, 3].my_count

print [1, 2, 3, 4, 5, 3, 3, 3, 3, 3, 3].my_map { |x| x + 3}

puts

print [1, 2, 3, 4, 5, 3, 3, 3, 3, 3, 3].my_inject(:+)

puts
puts multiply_els([1, 2, 3, 4, 5, 3, 3, 3, 3, 3, 3])
