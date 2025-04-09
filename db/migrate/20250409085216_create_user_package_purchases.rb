class CreateUserPackagePurchases < ActiveRecord::Migration[7.1]
  def change
    create_table :user_package_purchases do |t|
      t.references :user, null: false, foreign_key: true
      t.references :package, null: false, foreign_key: true
      t.integer :units, default: 1, null: false
      t.datetime :start_date
      t.datetime :end_date
      t.decimal :total_amount, precision: 10, scale: 2
      t.integer :payment_status, default: 0
      t.string :invoice_number
      t.string :payment_reference
      t.datetime :payment_date
      t.text :admin_notes

      t.timestamps
    end
  end
end