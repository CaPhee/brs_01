class CreateActivities < ActiveRecord::Migration[5.0]
  def change
    create_table :activities do |t|
      t.references :user, foreign_key: true
      t.integer :target_id
      t.string :target_type
      t.string :integer

      t.timestamps
    end
  end
end
