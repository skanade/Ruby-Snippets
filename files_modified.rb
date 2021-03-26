# Number of files with file extensions
# List files modified in specified year, sorted by month
#
root_dir = ARGV.shift
year = ARGV.shift.to_i
ignore_dir = ARGV.shift
ignore_dirs = Array.new
if ignore_dir
  ignore_dirs = ignore_dir.split(",")
end

def reject_file(f, ignore_dirs)
  ignore_dirs.each do |ignore_dir|
    return true if f =~ /#{ignore_dir}/
  end
  return true if File.directory?(f)
  return false
end

# find files in root directory & sub directories
files = Dir.glob("#{root_dir}/**/*").reject{ |f| reject_file(f, ignore_dirs) }

file_extensions = Hash.new

result = Array.new

files.each do |file|
  modtime = File.mtime(file)
  if modtime.year.to_i == year
    result << file

    file_ext = File.extname(file)
    num_files = file_extensions[file_ext]
    num_files = 0 unless num_files
    num_files = num_files + 1
    file_extensions[file_ext] = num_files
  end
end

files_sorted = result.sort_by{|f| File.mtime(f)}
curr_month = nil
puts "======== #{year} ======"
puts "=== file_extensions ==="
file_extensions.each do |file_ext, num_files|
  puts "#{file_ext} => #{num_files} files"
end
puts

files_sorted.each do |file|
  mtime = File.mtime(file)
  if curr_month != mtime.month.to_i
    curr_month = mtime.month.to_i
    puts "    === #{curr_month} ==="
  end
  puts file
end
