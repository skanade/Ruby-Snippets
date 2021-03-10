require 'optparse'
require 'csv'

require_relative 'custom_data'

file1 = ARGV.shift
file2 = ARGV.shift

file1_table = CSV.read(file1, headers: true)
file2_table = CSV.read(file2, headers: true)

hash1 = Hash.new
hash2 = Hash.new

list1 = CustomData.to_list(file1_table)
list2 = CustomData.to_list(file2_table)

compare_result = CustomData.compare(list1, list2)
new_records = compare_result.new_records
puts "==== NEW RECORDS ====" if new_records.size > 0
new_records.each do |new_record|
  puts new_record
end
puts if new_records.size > 0

updated_records = compare_result.updated_records
puts "==== UPDATED RECORDS ====" if updated_records.size > 0
updated_records.each do |updated_record|
  puts updated_record
end
puts if updated_records.size > 0

deleted_records = compare_result.deleted_records
puts "==== DELETED RECORDS ====" if deleted_records.size > 0
deleted_records.each do |deleted_record|
  puts deleted_record
end
puts if deleted_records.size > 0


