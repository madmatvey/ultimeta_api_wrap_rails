class CreateTenders < ActiveRecord::Migration
  def change
    create_table :tenders do |t|
      t.jsonb :data, null: false, default: '{}'
      t.string :digest

      t.timestamps null: false
    end

    add_index  :tenders, :data, using: :gin
  end
end
