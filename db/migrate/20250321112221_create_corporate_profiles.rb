class CreateCorporateProfiles < ActiveRecord::Migration[7.1]
  def change
    create_table :corporate_profiles do |t|
      t.string :business_name
      t.text :description
      t.string :business_hours
      t.text :about
      t.string :logo
      t.text :address
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
