class AddConfirmationCodeToUser < ActiveRecord::Migration
  def change
    add_column :users, :confirmation_code, :string
    add_column :users, :confirmation_time, :timestamp
    add_column :users, :confirmed, :boolean, null: false, default: false
    add_column :users, :total_confirmations, :integer, null: false, default: 0
  end
end
