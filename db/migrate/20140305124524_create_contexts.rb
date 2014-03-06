class CreateContexts < ActiveRecord::Migration
  def change
    create_table :contexts do |t|
      t.string :name, :null => false
      t.integer :user_id, :null => false
      t.timestamps
    end
    add_index :contexts, :user_id
  end
end
