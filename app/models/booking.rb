class Booking < ApplicationRecord
  has_many :modification_requests
  has_many :cancellation_requests
end
