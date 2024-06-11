class AddBookingsTable < ActiveRecord::Migration[7.1]
  def change
    create_table :bookings do |t|
      t.integer :status, default: 0
      # Used decimal for the stored price for ease of use in this tech test, but an integer
      # could also be used to always store prices in minor units.
      # Allow 3 decimal places to allow % discounts to be stored without rounding to penny.
      # Allow 12 digits total allowing up to billions to be stored when 3 decimals are present.
      t.decimal :price, scale: 3, precision: 12

      t.timestamps
    end
  end
end
