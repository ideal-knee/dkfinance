class Transaction < ActiveRecord::Base
  belongs_to :category

  def self.create_from_csv_line(line)
    parts = line.split(',').map { |part| part.gsub '"', '' }

    if parts.length == 4
      date, description, amount, category_name = parts
      date = Date.parse(date)
      amount = amount.to_f
      category = Category.find_by(name: category_name) || Category.create(name: category_name)
      Transaction.create(date: date, description: description, amount: amount, category: category)
    else
      Rails.logger.info "Transaction.create_from_csv_line: Can't create transaction from '#{line}'"
      nil
    end
  end
end
