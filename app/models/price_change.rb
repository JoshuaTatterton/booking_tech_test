# This is a read only data layer over regular BookingPrices. This could
# also be moved to be manually done on the Booking.price_changes method
# if anything more complicated than attribute aliasing is required.
class PriceChange < ApplicationRecord
  self.table_name = :booking_prices

  belongs_to :booking

  def readonly?
    true
  end

  alias_attribute :price_updated_at, :created_at
end
