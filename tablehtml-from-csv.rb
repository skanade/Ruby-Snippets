require 'optparse'
require 'csv'

options = {}
opt_parser = OptionParser.new do |opts|
  opts.on("-f CSVFILE", "--file CSVFILE") do |file|
    options[:file] = file
  end
  opts.on("-h HEADERFILE", "--file HEADERFILE") do |file|
    options[:headerfile] = file
  end
end

opt_parser.parse!
file = options[:file]
headerfile = options[:headerfile]
#puts options.inspect

# write headerfile contents
header = File.open(headerfile)
header_data = header.read
puts header_data

table_name = File.basename(file, File.extname(file))

# generate bootstrap html table data
puts "<h2>#{table_name}</h2>"
puts "<table class='table'>"
puts "<thead>"
puts "<tr class='table-primary'>"

table = CSV.read(options[:file], headers: true)

table.headers.each_with_index do |column,index|
  puts "  <th scope='col'>#{column}</th>"
end
puts "</tr>"
puts "</thead>"

puts "<tbody>"
table.each do |row|
  puts "<tr>"
  table.headers.each_with_index do |column,index|
    value = row[column].strip
    puts "<td scope='col'>#{value}</td>"
  end
  puts "</tr>"
end
puts "</tbody>"
puts "</table>"

