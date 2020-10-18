require 'optparse'
require 'csv'

class ItemStatus
  def initialize(key, group, item, status, prefix="", link_prefix="")
    @key = key
    @group = group
    @item = item
    @status = status
    @prefix = prefix
    @link_prefix = link_prefix
  end
  def to_markdown
    if @link_prefix == ""
      return "* #{@key}:#{@item} (#{@status})" 
    else
      return "* \"#{@prefix}#{@key}\":#{@link_prefix}#{@key} #{@item} (#{@status})" 
    end
  end
end

options = {}
opt_parser = OptionParser.new do |opts|
  opts.on("-f CSVFILE", "--file CSVFILE") do |file|
    options[:file] = file
  end
  opts.on("-p KEY_PREFIX", "--prefix KEY_PREFIX") do |prefix|
    options[:prefix] = prefix
  end
  opts.on("-l LINK_PREFIX", "--link_prefix LINK_PREFIX") do |link_prefix|
    options[:link_prefix] = link_prefix
  end
end

opt_parser.parse!
file = options[:file]
prefix = options[:prefix]
link_prefix = options[:link_prefix]

#puts options.inspect
file_table = CSV.read(file, headers: true)

items_by_group = Hash.new

file_table.each do |row|
  key = row["key"]
  group = row["group"]
  item = row["item"]
  status = row["key"]

  item_status = ItemStatus.new(key, group, item, status, prefix, link_prefix)
  #puts "#{key} => group: #{group} item: #{item} status: #{status}"
  group_items = items_by_group[group]
  unless group_items
    group_items = Array.new
  end
  group_items << item_status
  items_by_group[group] = group_items
end

items_by_group.each do |key,list|
  puts "h2. #{key}"
  list.each do |item_status|
    puts item_status.to_markdown
  end
end
