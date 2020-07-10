require_relative "scan"

mkdown_filename = ARGV.shift

File.open(mkdown_filename, 'r') do |file|
  lines = file.readlines
  scan = Scan.new(lines)
  scan.scan_tokens();
  puts scan.to_html
end

