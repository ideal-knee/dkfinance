class Transaction < ActiveRecord::Base
  belongs_to :category
  belongs_to :user

  validates :user, :presence => true

  def self.create_from_csv_line(line, user)
    parts = CSV.parse(line).first

    if parts.length == 4
      date, description, amount, category_name = parts
      date = Date.parse(date)
      amount = amount.to_f
      category = Category.find_or_create_by(name: category_name, user: user)
      Transaction.create(date: date, description: description, amount: amount, category: category, user: user)
    else
      Rails.logger.info "Transaction.create_from_csv_line: Can't create transaction from '#{line}'"
      nil
    end
  end
end
