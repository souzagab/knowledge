class CreateContents < ActiveRecord::Migration[7.0]
  def change
    create_table :contents do |t|
      t.references :course, null: false, foreign_key: true

      t.string :name, null: false, index: true
      t.text   :description, default: ""

      t.timestamps
    end
  end
end
