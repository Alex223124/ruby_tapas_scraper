require 'nokogiri'
require 'open-uri'
require 'pry'

unless ENV["RT_USERNAME"] && ENV["RT_PASSWORD"]
  puts "Need to set RT_USERNAME and RT_PASSWORD environment variables"
  exit(1)
end

options = {
  http_basic_authentication: [ ENV["RT_USERNAME"], ENV["RT_PASSWORD"] ]
}

contents = open('https://rubytapas.dpdcart.com/feed', options).read
doc = Nokogiri::XML(contents)

doc.css('enclosure').each do |enclosure|
  url = enclosure.attributes["url"].value
  file_name = url.split('/').last
  puts "#{file_name}, #{url}"

  if File.exist?(file_name)
    puts "Already have this one"
  else
    open(file_name, 'w').write(open(url, options).read)
  end
end
