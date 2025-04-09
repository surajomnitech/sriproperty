class EnhancePackagesTable < ActiveRecord::Migration[7.1]
  def change
    change_table :packages do |t|
      t.integer :duration_days, default: 30, null: false
      t.integer :free_listings_per_cycle, default: 0, null: false
      t.integer :max_paid_listings, default: 1, null: false
      t.integer :listing_duration_days, default: 60, null: false
      t.decimal :price, precision: 10, scale: 2, default: 0.0, null: false
      t.boolean :invoice_required, default: false
    end

    # Update existing packages with some sensible defaults
    reversible do |dir|
      dir.up do
        execute <<-SQL
          UPDATE packages 
          SET free_listings_per_cycle = free_listings_count,
              max_paid_listings = 0,
              duration_days = 30,
              listing_duration_days = 60,
              price = 0.0,
              invoice_required = false
        SQL
      end
    end
  end
end