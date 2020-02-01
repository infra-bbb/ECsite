class CreateAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :addresses do |t|
      t.string :recipient_name, null: false
      t.string :postal_code, null: false
      t.string :address, null: false
      t.integer :end_user_id, null: false

      t.timestamps
    end
  end
end
