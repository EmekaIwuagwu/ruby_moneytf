class CreateCustomers < ActiveRecord::Migration[7.1]
  def change
    create_table :customers do |t|
      t.string :fullname
      t.string :address
      t.string :city
      t.string :state
      t.string :email
      t.string :telephone
      t.string :account_number
      t.decimal :balance, precision: 10, scale: 2, default: 0.00

      t.timestamps
    end
  end
end
