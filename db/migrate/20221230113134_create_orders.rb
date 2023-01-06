class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.string :name, null: false
      t.integer :point, null: false, default: 0
      t.string :buyer, null: false
      t.string :seller, null: false
      t.references :user, null: false, foreign_key: true
      t.references :item, null: false, foreign_key: true

      t.timestamps
    end
  end
end
