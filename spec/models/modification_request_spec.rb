describe ModificationRequest do
  describe "#approve!" do
    it "updates the status to `approved`" do
      # Arrange
      booking = Booking.create(status: :confirmed, price: 10)
      modification_request = booking.modification_requests.new(price: 5)
      allow(booking).to receive(:modify!).and_return(true)

      # Act
      modification_request.approve!

      # Assert
      aggregate_failures do
        expect(modification_request).to be_persisted
        expect(modification_request.status).to eq("approved")
      end
    end

    it "calls to modify! on the booking with the new price" do
      # Arrange
      booking = Booking.create(status: :confirmed, price: 10)
      modification_request = booking.modification_requests.new(price: 5)
      allow(booking).to receive(:modify!).and_return(true)
 
      # Act
      modification_request.approve!

      # Assert
      expect(booking).to have_received(:modify!).with(new_price: 5).once
    end
  end
end
