class CreateItems < ActiveRecord::Migration[6.0]
  def change
    create_table :items do |t|
      t.string :name, null: false
      t.integer :point, null: false, default: 0
      t.boolean :del, null: false, default: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
