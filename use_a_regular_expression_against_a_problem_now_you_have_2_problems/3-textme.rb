#!/usr/bin/ruby
# scan given argument, use lookbehind to get data that follows from, to, flags
# and ends before closing square bracket.
puts ARGV[0].scan(/(?<=\[from:)\+?\w+|(?<=\[to:)\+?\w+|(?<=\[flags:)[\-?\d\:]+/).join(',')
