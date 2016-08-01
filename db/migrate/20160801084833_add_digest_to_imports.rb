class AddDigestToImports < ActiveRecord::Migration
  def change
    add_column :imports, :digest, :string
  end
end
