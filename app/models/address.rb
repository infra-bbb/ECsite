class Address < ApplicationRecord
  belongs_to :end_user
  with_options presence: true do
    validates :recipient_name
    validates :postal_code
    validates :address
    validates :end_user_id
  end
end
