#!/usr/bin/ruby

require 'io/console'

text = open(ARGV[0]).read.strip

# puts "\e[H\e[2J"
slice = IO.console.winsize[1]/2
catch :finish do
  text.split.each do |line|
    line.chars.each_slice(slice) do |breaked_line|
      puts breaked_line.join
      breaked_line.each do |char|
        while input = STDIN.getch do
          case input
          when "\u0003"
            throw :finish
          when char
            putc char
            break
          end
        end
      end
      puts
    end
  end
end
