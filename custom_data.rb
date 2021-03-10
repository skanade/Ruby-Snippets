require 'csv'

class Key
  attr_accessor :first, :last

  def initialize(first, last)
    @first = first
    @last = last
  end
  def eql?(other)
    return false if self.first != other.first 
    return false if self.last != other.last     
    return true
  end
  def hash
    [@first, @last].hash
  end
  def to_s
    "first: #{@first}, last: #{@last}"
  end
end
class Value
  attr_accessor :age, :occupation

  def initialize(age, occupation)
    @age = age
    @occupation = occupation
  end
  def eql?(other)
    return false if self.age != other.age 
    return false if self.occupation != other.occupation     
    return true
  end
  def hash
    [@age, @occupation].hash
  end
  def to_s
    "age: #{@age}, occupation: #{@occupation}"
  end
end
class CustomCompareResult
  attr_accessor :num_records_same
  def initialize(old_data, new_data)
    @old_data = old_data
    @new_data = new_data

    compare_num_records
  end
  def compare_num_records
    if @old_data.size == @new_data.size
      @num_records_same = true
    else
      @num_records_same = false
    end
  end
  def new_records
    result = Array.new
    puts "old_data: #{@old_data}" if $DEBUG
    @new_data.each do |new_item|
      puts "old_data.find(#{new_item.key})" if $DEBUG
      old_item = @old_data.find_by_key(new_item.key)
      puts "old_item: #{old_item}" if $DEBUG
      unless old_item
        result << new_item
      end
    end
    return result
  end
  def updated_records
    result = Array.new
    puts "old_data: #{@old_data}" if $DEBUG 
    @old_data.each do |old_item|
      puts "new_data.find(#{old_item.key})" if $DEBUG 
      new_item = @new_data.find_by_key(old_item.key)
      puts "new_item: #{new_item}" if $DEBUG 
      if new_item
        unless new_item.value.eql?(old_item.value)
          result << new_item
        end
      end
    end
    return result
  end
  def deleted_records
    result = Array.new
    puts "old_data: #{@old_data}" if $DEBUG 
    @old_data.each do |old_item|
      puts "new_data.find(#{old_item.key})" if $DEBUG 
      new_item = @new_data.find_by_key(old_item.key)
      puts "new_item: #{new_item}" if $DEBUG 
      unless new_item
        result << old_item
      end
    end
    return result
  end
end
class CustomData
  attr_accessor :key, :value
  def initialize(first, last, age, occupation)
    @key = Key.new(first, last)
    @value = Value.new(age, occupation)
  end
  def to_s
    "#{@key} => value: #{@value}"
  end
  def self.to_data(row)
    first = row['First']
    last = row['Last']
    age = row['Age']
    occupation = row['Occupation']
    data = CustomData.new(first, last, age, occupation)
  end
  def self.to_list(file_table)
    list = CustomDataList.new
    file_table.each do |row|
      data = to_data(row)

      list.add(data)
    end
    return list
  end
  def self.compare(old_data, new_data)
    result = CustomCompareResult.new(old_data, new_data)
    return result
  end
end
class CustomDataList
  include Enumerable

  def initialize
    @hash = Hash.new
    @hash_indexed = Hash.new
    @index = 0
  end
  def find_by_key(key)
    @hash[key]
  end
  def add(data)
    @hash[data.key] = data
    @hash_indexed[@index] = data
    @index = @index + 1
  end
  def each
    @hash.each do |key,value|
      yield value
    end
  end
  def size
    @hash.size
  end
  def [](index)
    @hash_indexed[index]
  end
end

