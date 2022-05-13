class CreateAuthors < ActiveRecord::Migration[7.0]
  def change
    create_table :authors do |t|
      t.belongs_to :book, null: false, foreign_key: true
      t.string :name

      t.timestamps
    end
    add_index :authors, [:book_id, :name], unique: true
  end
end
