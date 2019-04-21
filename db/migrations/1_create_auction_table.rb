Sequel.migration do
  change do
    create_table(:auctions) do
      primary_key :id
      String :url, null: false
      String :closing, null: false
      String :pye_id, null: false
      String :page_one_url, null: false
      String :notes, text: true
    end
  end
end
