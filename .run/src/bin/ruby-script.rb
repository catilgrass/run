#!/usr/bin/env ruby

cwd = Dir.pwd
args = ARGV.map { |a| "\"#{a}\"" }.join(", ")

puts
puts '  Welcome to use `run.sh` / `run.ps1`'
puts
puts '  > "Hello World"'
puts "  > cwd  : \"#{cwd}\""
puts "  > args : #{args}"
puts
