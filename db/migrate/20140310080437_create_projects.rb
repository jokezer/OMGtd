class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :title, :null => false
      t.string :name
      t.string :content
      t.integer :user_id, :null => false
      t.integer :prior_id
      t.string :state
      t.datetime :expire
      t.timestamps
    end
    add_index :projects, :user_id
  end
end
