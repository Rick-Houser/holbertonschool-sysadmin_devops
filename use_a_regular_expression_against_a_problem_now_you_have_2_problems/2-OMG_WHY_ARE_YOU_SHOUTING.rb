#!/usr/bin/ruby
print ARGV.to_s.scan(/[[A-Z]!]/).join + "\n"
