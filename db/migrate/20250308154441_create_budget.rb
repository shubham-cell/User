class CreateBudget < ActiveRecord::Migration[8.0]
  def change
    create_table :budgets do |t|
      t.references :new_user, null: false, foreign_key: true
      t.integer :amount
      t.integer :budget_category
      t.timestamps
    end
  end
end
