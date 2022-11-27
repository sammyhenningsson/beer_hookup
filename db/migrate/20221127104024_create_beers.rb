class CreateBeers < ActiveRecord::Migration[7.0]
  def change
    create_table :beers do |t|
      t.integer :external_id, null: false, index: {unique: true}
      t.string :data, null: false

      t.timestamps
    end
  end
end
