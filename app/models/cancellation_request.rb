class CancellationRequests < ApplicationRecord
  belongs_to :booking

  enum :status, { pending: 0, approved: 1 }
end
