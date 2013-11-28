class Transaction < ActiveRecord::Base
  belongs_to :category

  def self.create_from_csv_line(line)
    line
  end
end
