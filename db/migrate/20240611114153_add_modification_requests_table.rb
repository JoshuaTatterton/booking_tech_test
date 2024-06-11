class AddModificationRequestsTable < ActiveRecord::Migration[7.1]
  def change
    create_table :modification_requests do |t|
      t.integer :status, default: 0
      t.decimal :price, scale: 3, precision: 12

      t.timestamps

      t.belongs_to :booking, null: false, foreign_key: true
    end
  end
end
