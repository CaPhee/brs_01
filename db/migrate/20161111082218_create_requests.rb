class CreateRequests < ActiveRecord::Migration[5.0]
  def change
    create_table :requests do |t|
      t.references :book, foreign_key: true
      t.references :user, foreign_key: true
      t.string :description
      t.boolean :processed, default: false
      t.boolean :deleted, default: false

      t.timestamps
    end
  end
end
