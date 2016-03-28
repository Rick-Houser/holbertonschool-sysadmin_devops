#!/usr/bin/ruby
# search argument for alphanumeric character,
# then make a string from each element using .join
puts ARGV[0].scan(/\w+/).join
