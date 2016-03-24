#!/usr/bin/ruby
# searches argument for pattern starting with 1+ alphanumeric character, followed by
# 0/1 space and followd by 0+ other alphanumeric character.
puts ARGV[0].match /(^\w+\s?)\w*/
