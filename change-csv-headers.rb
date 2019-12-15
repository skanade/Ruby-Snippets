require 'optparse'
require 'csv'
require 'yaml'

options = {}
opt_parser = OptionParser.new do |opts|
  opts.on("-f CSVFILE", "--file CSVFILE") do |file|
    options[:file] = file
  end
  opts.on("-y HEADER_COLUMNS_YAML", "--yaml HEADER_COLUMNS_YAML") do |file|
    options[:headers_yaml] = file
  end
end

opt_parser.parse!
file = options[:file]
headers_yaml = options[:headers_yaml]
@headers = YAML.load_file(headers_yaml)

def header_column_name(column)
  column = column.strip
  header_new_name = @headers[column]
  return header_new_name if header_new_name
  return column
end

table_name = File.basename(file, File.extname(file))
#puts options.inspect
table = CSV.read(options[:file], headers: true)
table.headers.each_with_index do |column,index|
  header_col_name = header_column_name(column)
  print header_col_name
  print "," unless index == table.headers.size - 1
end
puts

table.each do |row|
  table.headers.each_with_index do |column,index|
    value = row[column].strip
    print value
    print "," unless index == table.headers.size - 1
  end
  puts 
end
