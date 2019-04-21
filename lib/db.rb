require 'sequel'
DB ||= Sequel.connect("sqlite://db/auctionscraper.sqlite")

class Auction < Sequel::model
  one_to_many :items

end

class Item < Sequel::model
  many_to_one :auction

end
