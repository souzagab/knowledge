class CreateCourses < ActiveRecord::Migration[7.0]
  def change
    create_table :courses do |t|
      t.string :title, null: false, index: true
      t.text :description, null: false

      t.timestamps
    end
  end
end
