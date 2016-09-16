class CreateTodoItems < ActiveRecord::Migration[5.0]
  def change
    create_table :todo_items do |t|
      t.text :description
      t.boolean :completed, default: true
      t.references :todo_list, foreign_key: true

      t.timestamps
    end
  end
end
