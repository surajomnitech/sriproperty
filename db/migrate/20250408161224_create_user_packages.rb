class CreateUserPackages < ActiveRecord::Migration[7.1]
  def change
    create_table :user_packages do |t|
      t.references :user, null: false, foreign_key: true
      t.references :package, null: false, foreign_key: true
      t.integer :listings_consumed
      t.integer :status

      t.timestamps
    end
  end
end
