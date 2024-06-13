require "modules/backfill_booking_prices"

describe "BackfillBookingPrices" do
  describe "#call" do
    it "creates BookingPrices for confirmed & cancelled Bookings with no existing BookingPrices" do
      # Arrange
      # Bookings to create prices for
      confirmed_booking_no_price = Booking.create(status: :confirmed, price: 10)
      cancelled_booking_no_price = Booking.create(status: :cancelled, price: 0)
      # Booking to not create prices for
      pending_booking_no_price = Booking.create(status: :pending, price: 10)
      confirmed_booking_with_price = Booking.create(status: :confirmed, price: 10)
      confirmed_booking_with_price.booking_prices.create(price: 10)
      cancelled_booking_with_price = Booking.create(status: :cancelled, price: 0)
      cancelled_booking_with_price.booking_prices.create(price: 0)

      # Act & Assert
      expect {
        BackfillBookingPrices.new.call
      }.to change(BookingPrice, :count).from(2).to(4)

      # Assert
      aggregate_failures do
        # Unchanged prices
        expect(pending_booking_no_price.booking_prices.count).to eq(0)
        expect(confirmed_booking_with_price.booking_prices.count).to eq(1)
        expect(cancelled_booking_with_price.booking_prices.count).to eq(1)
        # Changed prices
        expect(confirmed_booking_no_price.booking_prices.count).to eq(1)
        expect(confirmed_booking_no_price.booking_prices.first.price).to eq(10)
        expect(cancelled_booking_no_price.booking_prices.count).to eq(1)
        expect(cancelled_booking_no_price.booking_prices.first.price).to eq(0)
      end
    end

    it "returns the number of bookings that have had prices created" do
      # Arrange
      # Booking to not create prices for
      Booking.create(status: :pending, price: 10)
      # Bookings to create prices for
      Booking.create(status: :confirmed, price: 10)
      Booking.create(status: :cancelled, price: 0)

      # Act
      count = BackfillBookingPrices.new.call

      # Assert
      expect(count).to eq(2)
    end

    it "creates BookingPrices for Bookings up to the batch_size provided" do
      # Arrange
      # Bookings to create prices for
      booking_1 = Booking.create(status: :confirmed, price: 10)
      # Price should not be created due to batch size
      booking_2 = Booking.create(status: :cancelled, price: 0)

      # Act
      expect {
        BackfillBookingPrices.new(batch_size: 1).call
      }.to change(BookingPrice, :count).by(1)

      # Assert
      aggregate_failures do
        # Changed prices
        expect(booking_1.booking_prices.count).to eq(1)
        expect(booking_1.booking_prices.first.price).to eq(10)
        # Unchanged prices
        expect(booking_2.booking_prices.count).to eq(0)
      end
    end
  end
end
