class CreateRsvps < ActiveRecord::Migration[5.2]
  def change
    create_table :rsvps do |t|
      t.references :user, foreign_key: true
      t.references :event, foreign_key: true
      t.integer    :status

      t.timestamps
    end
  end
end
