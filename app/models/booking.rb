class Booking < ApplicationRecord
  has_many :modification_requests
  has_many :cancellation_requests

  # While status is not necessary on booking it is helpful for expressing intent
  # in other methods by encapsulating it in the status updates.
  enum :status, { pending: 0, confirmed: 1, cancelled: 2 }

  def guest_price
    price || BookingCalculator.new.call
  end

  def confirm!
    update!(status: :confirmed, price: guest_price)
  end

  def modify!(new_price:)
    # Setting status just incase a pending/cancelled Booking is modified.
    # It should have been cause by validations (skipped for tech test) but in the
    # scenario it gets by it makes more sense to see a confirmed Booking with a price
    # rather than a pending/cancelled Booking with a stored/non zero price.
    update!(status: :confirmed, price: new_price)
  end

  def cancel!
    update!(status: :cancelled, price: 0)
  end
end
