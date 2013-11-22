class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.string :description
      t.float :amount
      t.date :date
      t.integer :category_id

      t.timestamps
    end
  end
end
