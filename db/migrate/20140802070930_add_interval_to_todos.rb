class AddIntervalToTodos < ActiveRecord::Migration
  def change
    add_column :todos, :interval, :string
  end
end
