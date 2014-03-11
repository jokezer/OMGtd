class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :title, :null => false
      t.string :content
      t.integer :user_id, :null => false
      t.integer :prior_id
      t.datetime :expire
      t.timestamps
    end
  end
end
