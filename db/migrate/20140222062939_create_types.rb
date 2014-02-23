class CreateTypes < ActiveRecord::Migration
  def change
    create_table :types do |t|
      t.string :label
    end
  end
end
