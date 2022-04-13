class CreateTrades < ActiveRecord::Migration[6.1]
  def change
    create_table :trades do |t|
      t.integer :trade_type
      t.belongs_to :bank_account, foreign_key: true
      t.string :symbol
      t.integer :shares
      t.integer :price
      t.integer :state
      t.time :timestamp
      t.timestamps
    end
  end
end
