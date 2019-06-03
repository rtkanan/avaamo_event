class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.string :title, null: false, default: ""
      t.string :description, null: false, default: ""
      t.datetime :starttime
      t.datetime :endtime
      t.boolean :allday, null: false, default: false
      t.boolean :is_complete, null: false, default: false

      t.timestamps
    end
  end
end
