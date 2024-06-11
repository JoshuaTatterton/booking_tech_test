class CancellationRequest < ApplicationRecord
  belongs_to :booking

  enum :status, { pending: 0, approved: 1 }

  def approve!
    transaction do
      update!(status: :approved)
      booking.cancel!
    end
  end
end
