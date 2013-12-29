class AnalyzeController < ApplicationController
  before_filter :authenticate_user!

  def month_to_month
    paycheck_category = current_user.categories.find_by(name: 'Paycheck')
    other_categories = current_user.categories.where.not(name: ['Paycheck', 'Uncategorized'])
    @results = []
    @categories = other_categories.map { |c| c.name.to_sym }
    12.times do |i|
      date = (Date.today - i.months)
      date_range = date.beginning_of_month..date.end_of_month
      by_category = {}
      other_categories.each do |category|
        by_category[category.name.to_sym] = current_user.transactions.where(category_id: category.id, date: date_range).sum(:amount)
      end
      @results << {
        month: date.strftime('%B %Y'),
        net: current_user.transactions.where(date: date_range).sum(:amount),
        income: current_user.transactions.where(category_id: paycheck_category.id, date: date_range).sum(:amount),
        by_category: by_category
      }
    end
  end
end
