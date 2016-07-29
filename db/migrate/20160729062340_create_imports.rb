class CreateImports < ActiveRecord::Migration
  def change
    create_table :imports do |t|
      t.integer :time_from
      t.integer :time_to
      t.jsonb :data, null: false, default: '{}'

      t.timestamps null: false
    end

    add_index  :imports, :data, using: :gin
  end
end
