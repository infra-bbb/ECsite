class Item < ApplicationRecord
  with_options presence: true do
    validates :name
    validates :price
    validates :genre_id
    validates :status
  end

  has_many :cart_items, dependent: :destroy
  has_many :order_details
  belongs_to :genre

  enum status: { 販売中: true, 販売停止中: false }

  def self.search(search)
    return Item.all unless search
    Item.where(['name LIKE ?', "%#{search}%"])
  end


end
