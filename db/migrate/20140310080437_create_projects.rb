class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :title, :null => false
      t.string :name
      t.text :content
      t.integer :user_id, :null => false
      t.integer :prior
      t.string :state
      t.datetime :due
      t.timestamps
    end
    add_index :projects, :user_id
  end
end
