require 'optparse'
require 'csv'
require 'yaml'

options = {}
opt_parser = OptionParser.new do |opts|
  opts.on("-y HEADER_COLUMNS_YML", "--yml HEADER_COLUMNS_YML", "YML with header mappings" ) do |file|
    options[:headers_yml] = file
  end
  executable_name = File.basename($PROGRAM_NAME)
  opts.banner = "Usage: #{executable_name} [options] csv_filename"
end

opt_parser.parse!
if ARGV.empty?
  puts "Error: you must provide a csv_filename"
  puts
  puts opt_parser.help
  exit 1
else
  file = ARGV[0]
end

headers_yml = options.fetch(:headers_yml, 'table_foo.yml')
@headers = YAML.load_file(headers_yml)

def header_column_name(column)
  column = column.strip
  header_new_name = @headers[column]
  return header_new_name if header_new_name
  return column
end

table_name = File.basename(file, File.extname(file))
#puts options.inspect
table = CSV.read(file, headers: true)
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
