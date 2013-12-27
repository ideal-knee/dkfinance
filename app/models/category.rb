class Category < ActiveRecord::Base
  belongs_to :user
  has_many :transactions

  validates :user, :presence => true
end
