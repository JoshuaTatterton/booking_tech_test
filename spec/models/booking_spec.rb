describe Booking do
  describe ".total_sales" do
    it "should return SalesCalculator value for a provided date range" do
      # Arrange
      dummy_calculator = double(:calculator, call: 25)
      allow(SalesCalculator).to receive(:new).and_return(dummy_calculator)
      start_date = 2.days.ago
      end_date = 1.day.ago

      # Act
      total_sales = Booking.total_sales(start_date: start_date, end_date: end_date)

      # Assert
      aggregate_failures do
        expect(total_sales).to eq(25)

        expect(SalesCalculator).to have_received(:new).with(start_date: start_date, end_date: end_date).once
        expect(dummy_calculator).to have_received(:call).once
      end
    end

    it "should default end date to current date if not provided" do
      # Arrange
      dummy_calculator = double(:calculator, call: 25)
      allow(SalesCalculator).to receive(:new).and_return(dummy_calculator)

      start_date = 2.days.ago
      current_date = "now"
      allow(Time).to receive(:now).and_return(current_date)

      # Act
      total_sales = Booking.total_sales(start_date: start_date)

      # Assert
      aggregate_failures do
        expect(total_sales).to eq(25)

        expect(SalesCalculator).to have_received(:new).with(start_date: start_date, end_date: current_date).once
        expect(dummy_calculator).to have_received(:call).once
      end
    end
  end

  describe "#guest_price" do
    it "should return the BookingCalculator price when no price is available" do
      # Arrange
      booking = Booking.new
      allow_any_instance_of(BookingCalculator).to receive(:call).and_return(25)

      # Act
      guest_price = booking.guest_price

      # Assert
      expect(guest_price).to eq(25)
    end

    it "should return the booking price value when present" do
      # Arrange
      booking = Booking.new(price: 15)
      allow_any_instance_of(BookingCalculator).to receive(:call).and_return(25)

      # Act
      guest_price = booking.guest_price

      # Assert
      expect(guest_price).to eq(15)
    end
  end

  describe "#price_changes" do
    it "returns PriceChanges in most recent order" do
      # Arrange
      booking = Booking.create(status: :confirmed, price: 11)
      first_price = booking.booking_prices.create!(price: 50, created_at: 3.day.ago)
      final_price = booking.booking_prices.create!(price: 11, created_at: 1.day.ago)
      second_price = booking.booking_prices.create!(price: 24, created_at: 2.day.ago)

      # Act
      price_changes = booking.price_changes

      # Assert
      expect(price_changes).to eq([
        PriceChange.find(final_price.id),
        PriceChange.find(second_price.id),
        PriceChange.find(first_price.id)
      ])
    end
  end

  describe "#confirm!" do
    it "updates the status to `confirmed`" do
      # Arrange
      booking = Booking.new

      # Act
      booking.confirm!

      # Assert
      aggregate_failures do
        expect(booking).to be_persisted
        expect(booking.status).to eq("confirmed")
      end
    end

    it "updates the price to the BookingCalculator price" do
      # Arrange
      booking = Booking.new
      allow_any_instance_of(BookingCalculator).to receive(:call).and_return(25)

      # Act
      booking.confirm!

      # Assert
      aggregate_failures do
        expect(booking).to be_persisted
        expect(booking.price).to eq(25)
      end
    end

    it "creates a BookingPrice with the BookingCalculator price" do
      # Arrange
      booking = Booking.new
      allow_any_instance_of(BookingCalculator).to receive(:call).and_return(25)

      # Act & Assert
      expect {
        booking.confirm!
      }.to change(BookingPrice, :count).by(1)

      # Assert
      booking_price = booking.booking_prices.last
      expect(booking_price.price).to eq(25)
    end
  end

  describe "#modify!" do
    it "updates the status to `confirmed`" do
      # Arrange
      booking = Booking.create(status: :cancelled, price: 10)

      # Act
      booking.modify!(new_price: 5)

      # Assert
      aggregate_failures do
        expect(booking).to be_persisted
        expect(booking.status).to eq("confirmed")
      end
    end

    it "updates the price to supplied new price" do
      # Arrange
      booking = Booking.create(status: :confirmed, price: 10)

      # Act
      booking.modify!(new_price: 5)

      # Assert
      aggregate_failures do
        expect(booking).to be_persisted
        expect(booking.price).to eq(5)
      end
    end

    it "creates a BookingPrice with the supplied new price" do
      # Arrange
      booking = Booking.create(status: :pending)
      booking.confirm!

      # Act
      expect {
        booking.modify!(new_price: 5)
      }.to change(BookingPrice, :count).from(1).to(2)

      # Assert
      booking_price = booking.booking_prices.last
      expect(booking_price.price).to eq(5)
    end
  end

  describe "#cancel!" do
    it "updates the status to `cancelled`" do
      # Arrange
      booking = Booking.create(status: :confirmed, price: 10)

      # Act
      booking.cancel!

      # Assert
      aggregate_failures do
        expect(booking).to be_persisted
        expect(booking.status).to eq("cancelled")
      end
    end

    it "updates the price to 0" do
      # Arrange
      booking = Booking.create(status: :confirmed, price: 10)

      # Act
      booking.cancel!

      # Assert
      aggregate_failures do
        expect(booking).to be_persisted
        expect(booking.price).to eq(0)
      end
    end

    it "creates a BookingPrice with a price of 0" do
      # Arrange
      booking = Booking.create(status: :confirmed, price: 10)

      # Act
      booking.cancel!

      # Assert
      booking_price = booking.booking_prices.last
      expect(booking_price.price).to eq(0)
    end
  end
end
