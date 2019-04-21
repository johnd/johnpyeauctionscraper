Sequel.migration do
  change do
    create_table(:items) do
      primary_key :id
      foreign_key :auction_id, :auctions
      String :url, null: false
      String :closing, null: false
      String :price, null: false
      String :image_url
      String :description, null: false
      Integer :item_number, null: false
      Time :last_scraped_at, null: false
      String :notes, text: true
    end
  end
end
