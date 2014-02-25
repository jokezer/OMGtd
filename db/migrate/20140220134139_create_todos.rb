class CreateTodos < ActiveRecord::Migration
  def change
    create_table :todos do |t|
      t.string :title, :null => false
      t.string :application
      t.integer :user_id, :null => false
      t.string :status, :length => 30
      t.integer :context_id
      t.integer :project_id
      t.datetime :expire

      t.timestamps

    end
    add_index :todos, :user_id
    add_index :todos, [:user_id, :context_id]
    add_index :todos, [:user_id, :project_id]
  end
end
