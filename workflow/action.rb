#!/usr/bin/env ruby

# action.rb
# createdby: Micah Rosales
# modified:  12/27/14
#
# Called by an alfred workflow with a JSON blob
# as the first argument. Parameter must have a
# type field and a arg field

require "json"

# Copies the given string to the OSX system
# clipboard using pbcopy and piping to stdin
def pbcopy(input)
    str = input.to_s
    IO.popen('pbcopy', 'w') { |f| f << str }
    str
end

begin
    args = JSON.parse(valid, :symbolize_names => true)
    arg = args[:arg]
    type = args[:type]
rescue NameError
    puts "Could not parse JSON!"
end

# geo cmds will have lat,lon format arg
if type == 'geo'
    `open "http://maps.apple.com/?sll=#{arg}"`
else
    # Otherwise copy to sys clipboard
    pbcopy(arg)
end
