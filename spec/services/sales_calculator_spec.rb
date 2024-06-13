describe SalesCalculator do
  # This kind of test wouldn't be added normally, but 
  context "Example from the Brief" do
    # For example, what is the total price of all bookings that were created in April at a
    # particular point in time. Let's say there were 100 bookings created during April 1-20
    # each for $1000, and 10 of them were cancelled on 25th April. As of May 14 total value
    # of the bookings is 90 * $1000 = $90K. However, as of April 24, the total value is $100K.
    before(:each) do
      # Setup 100 bookings of value 1000
      created_time = Time.new(2024, 4, 10)
      100.times do
        booking = Booking.create
        booking.booking_prices.create!(price: 1000, created_at: created_time)
      end

      # Set up 10 cancelled bookings
      cancelled_time = Time.new(2024, 4, 25, 12)
      Booking.order("RANDOM()").limit(10).each do |booking|
        booking.booking_prices.create!(price: 0, created_at: cancelled_time)
      end
    end

    it "May 14 should total 90k" do
      # Act
      may_14 = Time.new(2024, 5, 14, 23, 59)
      calculator = SalesCalculator.new(start_date: Time.new(2024, 4, 1), end_date: may_14)
      total_sales = calculator.call

      # Assert
      expect(total_sales).to eq(90_000)
    end

    it "April 24 should total 100k" do
      # Act
      april_24 = Time.new(2024, 4, 24, 23, 59)
      calculator = SalesCalculator.new(start_date: Time.new(2024, 4, 1), end_date: april_24)
      total_sales = calculator.call

      # Assert
      expect(total_sales).to eq(100_000)
    end
  end

  describe "#call" do
    context "sums up prices of BookingPrices," do
      it "includes prices within the provided date range" do
        # Arrange - 2 BookingPrices to find
        booking_1 = Booking.create
        booking_price_1 = booking_1.booking_prices.create!(price: 10, created_at: 3.days.ago)
        booking_2 = Booking.create
        booking_price_2 = booking_2.booking_prices.create!(price: 10, created_at: 3.days.ago)

        # Act
        calculator = SalesCalculator.new(start_date: 5.days.ago, end_date: 2.days.ago)
        total_sales = calculator.call

        # Assert
        expect(total_sales).to eq(20)
      end

      it "ignores prices outside the provided date range" do
        # Arrange - 2 BookingPrices to find
        booking_1 = Booking.create
        booking_1.booking_prices.create!(price: 10, created_at: 7.days.ago) # Too old
        booking_2 = Booking.create
        booking_2.booking_prices.create!(price: 10, created_at: 1.day.ago) # Too new

        # Act
        calculator = SalesCalculator.new(start_date: 5.days.ago, end_date: 2.days.ago)
        total_sales = calculator.call

        # Assert
        expect(total_sales).to eq(0)
      end

      it "includes only the most recent price for a booking within the date range" do
        # Arrange - 2 BookingPrices to find
        booking = Booking.create
        booking.booking_prices.create!(price: 1000, created_at: 7.days.ago) # Too old
        booking.booking_prices.create!(price: 100, created_at: 4.days.ago) # Within range but not the newest
        booking.booking_prices.create!(price: 10, created_at: 3.days.ago) # Within range and the newest
        booking.booking_prices.create!(price: 1, created_at: 1.day.ago) # Too new

        # Act
        calculator = SalesCalculator.new(start_date: 5.days.ago, end_date: 2.days.ago)
        total_sales = calculator.call

        # Assert
        expect(total_sales).to eq(10)
      end
    end
  end
end
