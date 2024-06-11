class AddCancellationRequestsTable < ActiveRecord::Migration[7.1]
  def change
    create_table :cancellation_requests do |t|
      t.integer :status, default: 0

      t.timestamps

      t.belongs_to :booking, null: false, foreign_key: true
    end
  end
end
