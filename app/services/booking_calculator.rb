# Service object which could calculate the correct price of a booking based on
# numerous factors, but at the moment it only exists to make testing easier by
# Being able to manipulate what this service object returns.
class BookingCalculator
  def call
    10
  end
end