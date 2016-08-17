#!/usr/bin/ruby

require 'io/console'

class Array
  def each_overlap(slice_size, overlap)
    if block_given?
		  i = 0
		  while i < length
		    yield slice(i...i+slice_size)
		    i += (slice_size - overlap)
		  end
    else
      to_enum(:each_overlap, slice_size, overlap)
    end
  end
end

text = open(ARGV[0]).read.strip

repeat = 1
repeat = ARGV[1].to_i if ARGV[1]

skip = 0
skip = ARGV[2].to_i if ARGV[2]

# puts "\e[H\e[2J"
slice = IO.console.winsize[1]/2 - 1
typed_chars = 0
start_time = nil
catch :finish do
  text.split.each do |line|
    line.chars.each_overlap(slice, 1) do |breaked_line|
      if skip > 0
        skip = skip - 1
        next
      end
      repeat.times do
        if line.size > slice
          print breaked_line[0..-2].join
          puts "  #{breaked_line[-1]}"
        else
          puts breaked_line.join
        end
        breaked_line.each_with_index do |char, index|
          break if index == slice - 1 and line.size > slice
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
end
finish_time = Time.now

if start_time
  puts
  speed = typed_chars * 60 / (finish_time - start_time)
  puts "Result: #{typed_chars} chars, #{speed.round(2)}/m"
end
