#!/usr/bin/ruby
print ARGV.to_s.scan(/[[:alpha:]]/).join + "\n"
