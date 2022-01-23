class CreateJwtDenylists < ActiveRecord::Migration[7.0]
  def change
    create_table :jwt_denylists do |t|
      t.string :jti, index: true
      t.datetime :exp

      t.timestamps
    end
  end
end
