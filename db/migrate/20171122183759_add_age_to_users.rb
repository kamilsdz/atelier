class AddAgeToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :age, :date
  end
end
