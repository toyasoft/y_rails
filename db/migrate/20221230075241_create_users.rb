class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :email, null: false, index: {unique: true}
      t.integer :point, null: false, default: 0
      t.string :password
      t.string :password_digest

      t.timestamps
    end
  end
end
