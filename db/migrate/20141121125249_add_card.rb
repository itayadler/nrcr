class AddCard < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.string 'code'
      t.string 'side'
      t.string 'card_type'
      t.string 'title'
      t.string 'description'
      t.string 'nrdb_url'
      t.string 'image_url'
    end
    add_index :cards, 'code'
  end
end
