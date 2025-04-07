class FixUserRoleAndStatus < ActiveRecord::Migration[7.1]
  def change
  end
end
class FixUserRoleAndStatus < ActiveRecord::Migration[7.1]
  def up
    # First, ensure role and status are string columns
    change_column :users, :role, :string
    change_column :users, :status, :string

    # Update existing records to use string values
    User.reset_column_information
    User.find_each do |user|
      user.update_columns(
        role: user.role.presence || 'individual',
        status: user.status.presence || 'pending'
      )
    end

    # Update your specific admin user
    User.where(email: 'suraj145@gmail.com').update_all(
      role: 'admin',
      status: 'active',
      admin: true
    )
  end

  def down
    # If you need to rollback, you can convert back to integers
    change_column :users, :role, :integer, using: "CASE role 
      WHEN 'admin' THEN 2 
      WHEN 'corporate' THEN 1 
      ELSE 0 END"
    
    change_column :users, :status, :integer, using: "CASE status 
      WHEN 'active' THEN 1 
      WHEN 'suspended' THEN 2 
      ELSE 0 END"
  end
end