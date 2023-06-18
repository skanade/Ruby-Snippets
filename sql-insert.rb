require 'optparse'
require 'csv'
# just adding a comment

class String
  def is_integer?
    self.to_i.to_s == self
  end
end

options = {}
opt_parser = OptionParser.new do |opts|
  opts.on("-f CSVFILE", "--file CSVFILE") do |file|
    options[:file] = file
  end
end

opt_parser.parse!
file = options[:file]
table_name = File.basename(file, File.extname(file))
#puts options.inspect
table = CSV.read(options[:file], headers: true)
table.each do |row|
  print "INSERT into #{table_name} ( "
  table.headers.each_with_index do |column,index|
    print column 
    print ", " unless index == table.headers.size - 1
  end
  puts " )"
  print "    VALUES ( "
  table.headers.each_with_index do |column,index|
    value = row[column].strip
    if value.is_integer?
      print value
    elsif value == "TRUE"
      print 1
    elsif value == "FALSE"
      print 0
    elsif value == ""
      print "null"
    else
      print "'#{value}'"
    end
    print ", " unless index == table.headers.size - 1
  end
  puts " )"
  puts "go"
  puts 
end
