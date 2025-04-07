class CreatePhoneNumbers < ActiveRecord::Migration[7.1]
  def change
    create_table :phone_numbers do |t|
      t.string :number
      t.boolean :verified, default: false
      t.boolean :primary, default: false
      t.string :verification_code
      t.datetime :code_expiry
      t.integer :verification_attempts, default: 0
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
