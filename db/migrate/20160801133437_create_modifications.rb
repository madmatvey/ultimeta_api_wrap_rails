class CreateModifications < ActiveRecord::Migration
  def change
    create_table :modifications do |t|
      t.text :data, :default => [].to_yaml
      t.references :tender, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
