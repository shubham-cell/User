class CreateTransaction < ActiveRecord::Migration[8.0]
  def change
    create_table :transactions do |t|
      t.integer :transaction_category
      t.string :description
      t.integer :amount
      t.references :new_user, null: false, foreign_key: true
      t.timestamps
    end
  end
end
