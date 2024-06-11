class AddBookingPrices < ActiveRecord::Migration[7.1]
  def change
    create_table :booking_prices do |t|
      t.decimal :price, scale: 3, precision: 12

      # Not using t.timestamps as there should be no time these are updated.
      t.datetime :created_at, null: false

      t.belongs_to :booking, null: false, foreign_key: true
    end

    add_index :booking_prices, :created_at, order: :desc
  end
end
