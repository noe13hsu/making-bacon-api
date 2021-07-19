class RenameCategoryTypeToCategoryType < ActiveRecord::Migration[6.1]
  def change
    rename_column :categories, :type, :category_type
  end
end
