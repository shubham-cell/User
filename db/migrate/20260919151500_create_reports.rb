class CreateReports < ActiveRecord::Migration[8.0]
  def change
    create_table :reports do |t|
      t.references :new_user, null: false, foreign_key: true
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.integer :status, default: 0, null: false
      t.string :error_message
      t.integer :transaction_count, default: 0, null: false

      t.timestamps
    end

    add_index :reports, [:new_user_id, :created_at]
  end
end
