class CreateOrderDetails < ActiveRecord::Migration[5.2]
  def change
    create_table :order_details do |t|
      t.integer :amount, null: false
      t.integer :subtotal, null: false
      t.integer :status, null: false, default: 0
      t.integer :order_id, null: false
      t.integer :item_id, null: false

      t.timestamps
    end
  end
end
