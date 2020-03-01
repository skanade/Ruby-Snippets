require 'optparse'
require 'csv'

options = {}
opt_parser = OptionParser.new do |opts|
  opts.on("-n NUM_COLUMNS_AS_KEY", "--num NUM_COLUMNS_AS_KEY") do |num|
    options[:num_columns_as_key] = num
  end
end
opt_parser.parse!

num_columns_as_key = options[:num_columns_as_key].to_i || 1

file1 = ARGV.shift
file2 = ARGV.shift

file1_table = CSV.read(file1)
file2_table = CSV.read(file2)

headers1 = file1_table.shift
headers2 = file2_table.shift
# create header column names by index
def headers_by_index(headers)
  result = Hash.new
  headers.each_with_index do |column, index|
    result[index] = column
  end
  result
end

headers_by_index = headers_by_index(headers1)

rows1 = file1_table
rows2 = file2_table

def row_key(row, num_columns_as_key)
  key = ""
  for col_index in 0...row.length
    val = row[col_index]
    key = "#{key}," if col_index >= 1
    key = "#{key}#{val}"

    if col_index >= num_columns_as_key - 1
      return key
    end
  end
  nil
end

def rows_by_key(rows, num_columns_as_key)
  rows_by_key = Hash.new
  rows.each_with_index do |row, index|
    key = row_key(row, num_columns_as_key)
    rows_by_key[key] = true
  end
  rows_by_key
end

rows1_by_key = rows_by_key(rows1, num_columns_as_key)
rows2_by_key = rows_by_key(rows2, num_columns_as_key)
#puts rows1_by_key
#puts rows2_by_key

# look in rows2 for NEW rows (not in rows1)
# create new rows2_removed with NEW rows removed
puts "=== NEW and DELETED records ==="
puts "Change =>,#{headers_by_index.values.to_csv}"
rows2_removed = Array.new
rows2.each do |row|
  key = row_key(row, num_columns_as_key)
  if rows1_by_key[key]
    rows2_removed << row
  else
    puts "NEW =>,#{row.to_csv}"
  end
end
rows1_removed = Array.new
# look in rows1 for rows not in rows2 (DELETE)
# create new rows1_removed with DELETED rows removed
rows1.each do |row|
  key = row_key(row, num_columns_as_key)
  if rows2_by_key[key]
    rows1_removed << row
  else
    puts "DELETED =>,#{row.to_csv}"
  end
end

rows1_removed.sort!
rows2_removed.sort!

puts
puts "=== Row by Row Comparison ==="
# compare rows in file1 to file2
for row_index in 0...rows1_removed.length
  row1 = rows1_removed[row_index]
  row2 = rows2_removed[row_index]
  for col_index in 0...row1.length
    val1 = row1[col_index]
    val2 = row2[col_index]
    if val1 != val2
      column_name = headers_by_index[col_index]
      puts "#{row_index}: #{column_name}: #{val1} => #{val2}"
    end
  end
end
