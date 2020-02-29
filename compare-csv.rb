require 'optparse'
require 'csv'

file1 = ARGV.shift
file2 = ARGV.shift

file1_table = CSV.read(file1)
file2_table = CSV.read(file2)

# create header column names by index
headers = file1_table.shift
headers_by_index = Hash.new
headers.each_with_index do |column, index|
  headers_by_index[index] = column
end

# sort rows from file1 
rows1 = file1_table
rows1.sort!

# sort rows from file2 
headers2 = file2_table.shift
rows2 = file2_table
rows2.sort!

# compare rows in file1 to file2
for row_index in 0...rows1.length
  row1 = rows1[row_index]
  row2 = rows2[row_index]
  for col_index in 0...row1.length
    val1 = row1[col_index]
    val2 = row2[col_index]
    if val1 != val2
      column_name = headers_by_index[col_index]
      puts "#{row_index}: #{column_name}: #{val1} => #{val2}"
    end
  end
end
