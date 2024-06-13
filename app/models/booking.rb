class Booking < ApplicationRecord
  has_many :booking_prices
  has_many :modification_requests
  has_many :cancellation_requests

  # Custom read only relationship which accesses booking_prices with a scope
  has_many :price_changes, -> { order(created_at: :desc) }

  # While status is not necessary on booking it is helpful for expressing intent
  # in other methods by encapsulating it in the status updates.
  enum :status, { pending: 0, confirmed: 1, cancelled: 2 }

  def guest_price
    price || BookingCalculator.new.call
  end

  def confirm!
    transaction do
      update!(status: :confirmed, price: guest_price)
      # These booking prices creation methods within `confirm!`, `modify!`, `cancel!`,
      # should be enough if the management of the bookings price is done exclusively
      # through these methods.
      # If not then it might be worth moving to an after update callback to create
      # booking prices across the board.
      # Another option could be to move it to a trigger within the database itself
      # to create booking prices when the Booking is updated, or possibly when a
      # Booking is confirmed and when Modify/Cancel requests are approved.
      booking_prices.create!(price: guest_price)
    end
  end

  def modify!(new_price:)
    transaction do
      # Setting status just incase a pending/cancelled Booking is modified.
      # It should have been caught by validations (skipped for tech test) but in the
      # scenario it gets by it makes more sense to see a confirmed Booking with a price
      # rather than a pending/cancelled Booking with a stored/non zero price.
      update!(status: :confirmed, price: new_price)
      booking_prices.create!(price: new_price)
    end
  end

  def cancel!
    transaction do
      # On cancel the price has be defaulted to 0, but it could accept a param like
      # `modify!`, or it could be generated from something like a deposit value.
      update!(status: :cancelled, price: 0)
      booking_prices.create!(price: 0)
    end
  end
end
