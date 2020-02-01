class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.integer :total_price, null: false
      t.integer :postage, null: false
      t.integer :payment_way, null: false
      t.string :recipient_name, null: false
      t.string :postal_code, null: false
      t.string :address, null: false
      t.integer :status, null: false, default: 0
      t.integer :end_user_id, null: false

      t.timestamps
    end
  end
end
