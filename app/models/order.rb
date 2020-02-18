class Order < ApplicationRecord
    with_options presence: true do
      validates :total_price
      validates :postage
      validates :payment_way
      validates :recipient_name
      validates :postal_code
      validates :address
      validates :status
      validates :end_user_id
    end
    enum payment_way: { クレジット: 0, 銀行振込: 1, 着払い: 2 }
    enum status: { 入金待ち: 0, 入金確認: 1, 製作中: 2, 発送準備中: 3, 発送済み: 4}

    belongs_to :end_user
    has_many :order_details

end