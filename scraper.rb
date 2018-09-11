require 'nokogiri'
require 'open-uri'

uri = ARGV[0]
max_price = (ARGV[1] || 4).to_i
page = 1
selector = "td:nth-child(4) a"
continue = true
matching_items = []

puts "Scraping for auctions at £#{max_price} or lower..."

while continue
  pageuri = uri + "&pageno=#{page}"
  puts "Scraping page #{page} at URI #{pageuri}..."
  doc = Nokogiri::HTML(open(pageuri))
  # Check if there's no more results
  if !doc.css('p font').empty?
    puts "No more items in this auction!"
    continue = false
    next
  end
  items = doc.css(selector).drop(1)
  items.each do |item|
    if item.children.first.children.first.text.gsub("£","").to_i <= max_price
      matching_items << "http://www.johnpyeauctions.co.uk/#{item.attributes["href"].value}"
    end
  end

  page += 1
end

if matching_items.empty?
  puts "No items found at or below target price!"
else
  puts "Items found at or below £#{max_price}..."
  matching_items.each do |item|
    puts item
  end
end
