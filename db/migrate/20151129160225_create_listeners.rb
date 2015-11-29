class CreateListeners < ActiveRecord::Migration
  def change
    create_table :listeners do |t|

      t.timestamps null: false
    end
  end
end
