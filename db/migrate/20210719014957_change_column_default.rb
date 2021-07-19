class ChangeColumnDefault < ActiveRecord::Migration[6.1]
  def change
    change_column_default :categories, :category_type, nil
  end
end
