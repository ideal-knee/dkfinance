class AddBudgetToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :budget, :integer
  end
end
