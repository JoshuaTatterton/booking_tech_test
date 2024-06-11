describe CancellationRequest do
  describe "#approve!" do
    it "updates the status to `approved`" do
      # Arrange
      booking = Booking.create(status: :confirmed, price: 10)
      cancellation_request = booking.cancellation_requests.new
      allow(booking).to receive(:cancel!).and_return(true)

      # Act
      cancellation_request.approve!

      # Assert
      aggregate_failures do
        expect(cancellation_request).to be_persisted
        expect(cancellation_request.status).to eq("approved")
      end
    end

    it "calls to cancel! on the booking" do
      # Arrange
      booking = Booking.create(status: :confirmed, price: 10)
      cancellation_request = booking.cancellation_requests.new
      allow(booking).to receive(:cancel!).and_return(true)
 
      # Act
      cancellation_request.approve!

      # Assert
      expect(booking).to have_received(:cancel!).once
    end
  end
end
