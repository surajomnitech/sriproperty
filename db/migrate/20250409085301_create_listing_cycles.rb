class CreateListingCycles < ActiveRecord::Migration[7.1]
  def change
    create_table :listing_cycles do |t|
      t.references :user_package_purchase, null: false, foreign_key: true
      t.datetime :cycle_start_date, null: false
      t.datetime :cycle_end_date, null: false
      t.integer :free_listings_used, default: 0
      t.integer :paid_listings_used, default: 0

      t.timestamps
    end

    add_index :listing_cycles, [:user_package_purchase_id, :cycle_start_date]
  end
end