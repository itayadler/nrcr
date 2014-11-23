class AddDeck < ActiveRecord::Migration
  def change
    create_table :decks do |t|
      t.integer :nrdb_id
      t.text :name
      t.datetime :creation_date
      t.text :description
      t.string :username
    end
  end
end
