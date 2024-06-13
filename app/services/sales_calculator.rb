class SalesCalculator
  def initialize(start_date:, end_date:)
    @start_date = start_date
    @end_date = end_date
  end

  def call
    sub_query = BookingPrice.select('DISTINCT ON ("booking_id") *')
      .where(created_at: @start_date..@end_date)
      .order(:booking_id, created_at: :desc, id: :desc)
      .to_sql
    BookingPrice.from("(#{sub_query})").sum(:price)
  end
end