#!/usr/bin/env ruby
# encoding: utf-8
($LOAD_PATH << File.expand_path("..", __FILE__)).uniq!

require 'rubygems' unless defined? Gem
require "bundle/bundler/setup"
require "alfred"
require 'json'
require "net/http"
require "uri"

Alfred.with_friendly_error do |alfred|
  fb = alfred.feedback
  uri = URI.parse("http://ip-api.com/json")
  http = Net::HTTP.new(uri.host, uri.port)
  request = Net::HTTP::Get.new(uri.request_uri)

  response = http.request(request)

  if response.code == "200"
    result = JSON.parse(response.body)
    city = result['city']
    region = result['region']
    country = result['country']
    zip = result['zip']
    location = "#{city} #{zip}, #{region}, #{country}"
    ip = result['query']
    isp = result['isp']
    lat = result['lat']
    lon = result['lon']

    fb.add_item({
      :uid      => '1'                    ,
      :title    => "External IP: #{ip}"    ,
      :subtitle => 'Cmd-c to copy'         ,
      :arg      => {:type => "ip", :arg => "#{ip}"}.to_json,
      :match?   => :all_title_match? ,
    })
    fb.add_item({
      :uid      => '2'                    ,
      :title    => "IP Location: #{location}"    ,
      :subtitle => "Open in Maps {#{lat}, #{lon}}" ,
      :match?   => :all_title_match?             ,
      :arg      => {:type => 'geo', :arg => "#{lat},#{lon}"}.to_json,
    })
    fb.add_item({
      :uid      => '3'                           ,
      :title    => "ISP: #{isp}"                 ,
      :subtitle => 'Cmd-c to copy'               ,
      :match?   => :all_title_match?             ,
      :arg      => {:type => 'isp', :arg => "#{isp}"}.to_json,
    })

  else
    # handle error
  end

  puts fb.to_alfred(ARGV)
end
