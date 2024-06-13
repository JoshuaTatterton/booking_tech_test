require "modules/backfill_booking_prices"

namespace :booking_prices do
  desc "Backfill historical Bookings with BookingPrice records"
  task backfill: :environment do
    batch_size = ENV.fetch("BACKFILL_BATCH_SIZE", 250).to_i
    limit = ENV.fetch("BACKFILL_LIMIT").to_i

    backfill_service = BackfillBookingPrices.new(batch_size: batch_size)

    bookings_updated = 250
    total_bookings_updated = 0
    batch_number = 1

    logger = Logger.new(STDOUT)

    logger.debug("Starting backfilling BookingPrices, limit: #{limit}, batch size: #{batch_size}")

    while(bookings_updated >= batch_size && total_bookings_updated < limit)
      bookings_updated = backfill_service.call

      logger.debug("\tBatch #{batch_number} completed, #{bookings_updated} Bookings updated.")

      total_bookings_updated += bookings_updated
      batch_number += 1

      sleep(0.5)
    end

    logger.debug("Backfilling #{total_bookings_updated} BookingPrices completed.")
  end
end