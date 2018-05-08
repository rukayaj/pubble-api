class CreateArtworks < ActiveRecord::Migration[5.1]
  def change
    create_table :artworks do |t|
      t.belongs_to :book, foreign_key: true
      t.integer :page
      t.integer :topic
      t.integer :source
      t.string :source_id
      t.string :copyright
      t.string :thumbnail_url
      t.string :notes

      t.timestamps
    end
  end
end
