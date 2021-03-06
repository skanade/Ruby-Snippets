# Demonstrates use of clipboard gem below:
# * https://github.com/janlelis/clipboard
#

require 'clipboard'

num_seconds = ARGV.shift || 5

clipboard = Hash.new

(1..num_seconds.to_i).each do |i|
  sleep 1
  value = Clipboard.paste
  unless clipboard[value]
    puts value
  end
  clipboard[value] = true
end
