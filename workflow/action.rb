#!/usr/bin/env ruby
require "json"

def logFile (filename, log)
    File.open(filename, 'w+') { |file|
        file.puts(log)
    }
end

def pbcopy(input)
    str = input.to_s
    IO.popen('pbcopy', 'w') { |f| f << str }
    str
end

args = JSON.parse(ARGV[0], :symbolize_names => true)
arg = args[:arg]
type = args[:type]


if type == 'geo'
    `open "http://maps.apple.com/?sll=#{arg}"`
else
    pbcopy(arg)
end
