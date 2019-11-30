
require 'optparse'
require 'csv'
require 'erb'

class String
  def is_integer?
    self.to_i.to_s == self
  end
  def to_sql_value
    if self == ""
      return "null"
    elsif self.is_integer?
      return self
    elsif self == "TRUE"
      return 1
    elsif self == "FALSE"
      return 0
    else
      return "'#{self}'"
    end
  end
end

options = {}
opt_parser = OptionParser.new do |opts|
  opts.on("-b BEFORE_CSVFILE", "--before BEFORE_CSVFILE") do |file|
    options[:before] = file
  end
  opts.on("-a AFTER_CSVFILE", "--after AFTER_CSVFILE") do |file|
    options[:after] = file
  end
end

opt_parser.parse!
before_file = options[:before]
after_file = options[:after]

table_name = File.basename(after_file, File.extname(after_file))
#puts options.inspect
before_table = CSV.read(before_file, headers: true)
after_table = CSV.read(after_file, headers: true)

def table_to_hash(table)
  key_column = nil
  key_value = nil
  table_hash = Hash.new
  table.each do |row|
    table.headers.each_with_index do |column,index|
      if index == 0
        key_column = column.strip 
        key_value = row[key_column].strip 
      end
      table_hash[key_value] = row
    end
  end
  return [key_column,table_hash]
end

key_column,before_table_hash = table_to_hash(before_table)
key_column,after_table_hash = table_to_hash(after_table)

#puts key_column
# must have same number of rows
if before_table_hash.count != after_table_hash.count
  puts "before_table count: #{before_table_hash.count}"
  puts "after_table count: #{after_table_hash.count}"
  exit
end
#puts before_table_hash
#puts after_table_hash

update_table_hash = Hash.new
before_table_hash.each do |key_column_value,before_row|
  after_row = after_table_hash[key_column_value]
  update_row_hash = Hash.new
  before_table.headers.each_with_index do |column,index|
    next if index == 0 # skip id column which is already captured as the key_column_value

    before_value = before_row[column].strip
    after_value = after_row[column].strip
    if after_value != before_value
      column_name = column.strip
      update_row_hash[column_name] = after_value
      update_table_hash[key_column_value] = update_row_hash
    end
    #puts column
    #puts "    #{before_value}"
    #puts "    #{after_value}"
    #puts update_row_hash
  end
end

#puts update_table_hash
update_table_hash.each do |key_column_value,update_row_hash|
  puts "UPDATE #{table_name}"
  print "SET "
  first_column = true
  update_row_hash.each do |column,value|
    print ", " unless first_column
    print "#{column} = "
    print value.to_sql_value
    first_column = false
  end
  puts 
  print "WHERE #{key_column} ="
  puts " #{key_column_value}"
  puts "go"
end


