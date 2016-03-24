#!/usr/bin/ruby
# scan arg for uppercase characters and exclamation points.
# finally, convert each element to string with .join
print ARGV[0].scan(/[[A-Z]!]/).join
