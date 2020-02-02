class Item < ApplicationRecord
  with_options presence: true do
    validates :name
    validates :price
    validates :genre_id
    validates :status
  end
  enum status: { 販売中: true, 販売停止中: false }
end
