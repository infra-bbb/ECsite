class OrderDetail < ApplicationRecord
    with_options presence: true do
      validates :amount
      validates :subtotal
      validates :status
      validates :item_id
    end
    enum status: { 着手不可: 0, 製作待ち: 1, 製作中: 2, 製作完了: 3 }
    belongs_to :order
    belongs_to :item

end
