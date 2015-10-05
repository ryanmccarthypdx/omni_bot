class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :location
      t.string :encrypted_phone
      t.string :password_hash
      t.string :password_salt
      t.timestamps null: false
    end
  end
end
