class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.string :name, null: false
      t.text :description #, null: false
      t.integer :price, null: false
      t.string :item_image_id#, null: false
      t.boolean :status, null: false
      t.integer :genre_id, null: false

      t.timestamps
    end
  end
end
