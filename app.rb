#!/usr/bin/ruby

require 'io/console'

text = open(ARGV[0]).read.strip

# puts "\e[H\e[2J"
slice = IO.console.winsize[1]/2
typed_chars = 0
start_time = nil
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
            start_time = Time.now if start_time === nil
            typed_chars = typed_chars + 1
            break
          end
        end
      end
      puts
    end
  end
end
finish_time = Time.now

speed = typed_chars * 60 / (finish_time - start_time)
puts "Result: #{typed_chars} chars, #{speed.round(2)}/m"
