class AddCardScore < ActiveRecord::Migration
  def change
    create_table :card_scores do |t|
      t.string :source_card_code
      t.string :dest_card_code
      t.float :score
    end
  end
end
