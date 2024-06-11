describe Booking do
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
  end
end
