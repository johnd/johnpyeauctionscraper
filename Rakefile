namespace :pye do
  namespace :scrape do
    desc "Scrape auction data"
    task :auction, [:url] do |t, args|
      require './lib/db'
      auction = Auction.new
      
      # ...
    end

    desc "Scrape items from auction"
    task :items, [:auction_id] do |t, args|
      require './lib/db'
      auction = Auction.where(id: args[:auction_id])
      
      # ...
    end
  end
end

namespace :db do
  desc "Run migrations"
  task :migrate, [:version] do |t, args|
    require "sequel/core"
    require "logger"
    Sequel.extension :migration
    version = args[:version].to_i if args[:version]
    Sequel.connect("sqlite://db/auctionscraper.sqlite", logger: Logger.new($stderr)) do |db|
      Sequel::Migrator.run(db, "db/migrations", target: version)
    end
  end
end

