class BackfillBookingPrices
  def initialize(batch_size: 100)
    @batch_size = batch_size
  end

  def call
    # Only adding data for Bookings that have been confirmed and don't have
    # existing BookingPrices any present will be ignored
    bookings = Booking.left_joins(:booking_prices)
      .where("booking_prices.price IS NULL")
      .where(status: [:confirmed, :cancelled])
      .limit(@batch_size)

    Booking.transaction do
      bookings.each do |booking|
        # Currently we are only creating a single BookingPrice per Booking,
        # with the updated_at as our best estimate of when the Booking became
        # that price, this is to try and preserve historical accuracy when
        # aggregating data.
        booking.booking_prices.create!(
          price: booking.guest_price,
          created_at: booking.updated_at
        )
        # This could be updated to create a BookingPrice for every approved
        # ModificationRequest and CancellationRequest for a Booking, to create
        # more price changes, but with the existing setup for Bookings and
        # prices, there is no way to know when the Booking was originally
        # `confirmed!` and what it's price point was if it has been modified
        # or cancelled since then.
      end
    end

    return bookings.size
  end
end
