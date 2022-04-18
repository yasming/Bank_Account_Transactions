class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :email
      t.boolean :active, default: 1
      t.string :name
      t.string :surname

      t.timestamps
    end
  end
end
