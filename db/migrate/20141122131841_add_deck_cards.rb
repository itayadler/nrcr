class AddDeckCards < ActiveRecord::Migration
  def change
    create_table :deck_cards do |t|
      t.string :card_code
      t.integer :deck_id
    end
  end
end
