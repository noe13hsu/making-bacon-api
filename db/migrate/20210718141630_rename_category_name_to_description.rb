class RenameCategoryNameToDescription < ActiveRecord::Migration[6.1]
  def change
    rename_column :categories, :name, :description
  end
end
