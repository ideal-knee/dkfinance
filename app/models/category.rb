class Category < ActiveRecord::Base
  belongs_to :user
  has_many :transactions

  validates :user, :presence => true

  def machine_name
    name.downcase.gsub(' ', '_')
  end

  def self.find_by_machine_name(machine_name)
    Category.find_by name: machine_name.titleize
  end
end
