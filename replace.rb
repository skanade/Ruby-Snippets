filename = ARGV.shift
text = ARGV.shift
replace_text = ARGV.shift

File.open(filename, 'r') do |file|
  lines = file.readlines
  lines.each do |line|
    new_line = line.gsub(text, replace_text)
    puts new_line
  end
end
