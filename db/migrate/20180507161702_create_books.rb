class CreateBooks < ActiveRecord::Migration[5.1]
  def change
    create_table :books do |t|
      t.string :country
      t.string :subject
      t.string :grade
      t.string :notes

      t.timestamps
    end
  end
end
