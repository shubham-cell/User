class CreateIncome < ActiveRecord::Migration[8.0]
  def change
    create_table :incomes do |t|
      t.decimal :amount, precision: 10, scale: 2
      t.integer :income_category
      t.references :new_user, null: false, foreign_key: true
      t.timestamps
    end
  end
end
