class CreateUserMetaData < ActiveRecord::Migration[8.0]
  def change
    create_table :user_meta_data do |t|
      t.string :name
      t.integer :age
      t.datetime :born_at

      t.timestamps
    end
  end
end
