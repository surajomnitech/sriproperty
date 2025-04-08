class CreatePackages < ActiveRecord::Migration[7.1]
  def change
    create_table :packages do |t|
      t.string :name
      t.integer :free_listings_count
      t.integer :max_photos_per_listing
      t.boolean :is_default
      t.integer :status

      t.timestamps
    end
  end
end
