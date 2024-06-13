class BookingPrice < ApplicationRecord
  belongs_to :booking

  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
