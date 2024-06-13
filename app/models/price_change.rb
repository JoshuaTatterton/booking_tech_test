class PriceChange < ApplicationRecord
  self.table_name = :booking_prices

  belongs_to :booking

  def readonly?
    true
  end

  alias_attribute :price_updated_at, :created_at
end
