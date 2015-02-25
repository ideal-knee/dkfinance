class Category < ActiveRecord::Base
  belongs_to :user
  belongs_to :parent_category, class_name: "Category", foreign_key: "parent_category_id"
  has_many :transactions
  has_many :child_categories, class_name: "Category", foreign_key: "parent_category_id"

  validates :user, :presence => true

  def machine_name
    name.downcase.gsub(' ', '_')
  end

  def self.find_by_machine_name(machine_name)
    Category.find_by name: machine_name.titleize
  end
end
