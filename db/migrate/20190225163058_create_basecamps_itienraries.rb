class CreateBasecampsItienraries < ActiveRecord::Migration[5.2]
  def change
    create_table :basecamps_itienraries do |t|
      t.references :itinerary, foreign_key: true
      t.references :basecamp, foreign_key: true

      t.timestamps
    end
  end
end
