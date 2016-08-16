#!/usr/bin/ruby

require 'io/console'

text = open(ARGV[0]).read.strip

# puts "\e[H\e[2J"
slice = IO.console.winsize[1]/2
text.chars.each_slice(slice) do |line|
  puts line.join
  line.each do |char|
    while input = STDIN.getch do
      case input
      when "\u0003"
        exit 0
      when char
        putc char
        break
      when "\r"
        if char == "\n"
          puts "\n"
          break
        end
      end
    end
  end
  puts
end
