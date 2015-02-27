class AnalyzeController < ApplicationController
  before_filter :authenticate_user!

  def month_to_month
    paycheck_category = current_user.categories.find_by(name: 'Paycheck')
    @categories = current_user.categories.where(parent_category_id: nil).where.not(name: 'Paycheck').order(:name)
    @results = []
    24.times do |i|
      date = (Date.today - i.months)
      date_range = date.beginning_of_month..date.end_of_month
      by_category = {}
      @categories.each do |category|
        by_category[category] = current_user.transactions.where(category_id: category.id, date: date_range).sum(:amount)
        by_category[category] += current_user.transactions.where(category_id: category.child_categories.map(&:id), date: date_range).sum(:amount)
      end
      @results << {
        date: date,
        net: current_user.transactions.where(date: date_range).sum(:amount),
        income: current_user.transactions.where(category_id: paycheck_category.id, date: date_range).sum(:amount),
        by_category: by_category
      }
    end
    respond_to do |format|
      format.html
      format.csv do
        csv = CSV.generate do |csv|
          csv << ["Date", "Net", "Income"] + @categories.map(&:name)
          @results.each do |result|
            csv << [result[:date].end_of_month, result[:net], result[:income]] + @categories.map { |category| result[:by_category][category] }
          end
        end
        render text: csv
      end
    end
  end

  def month_breakdown
    @category = Category.find_by_machine_name(params[:category])
    @start_date = Date.new(params[:year].to_i, params[:month].to_i)
    end_date = @start_date + 1.month
    category_ids = [@category.id] + @category.child_categories.map(&:id)
    @transactions = Transaction.where(user: current_user,
                                      category_id: category_ids,
                                      date: @start_date...end_date).order(:amount)
  end

  def month_breakdown_all
    @category = OpenStruct.new(name: "All Categories")
    @start_date = Date.new(params[:year].to_i, params[:month].to_i)
    end_date = @start_date + 1.month
    @transactions = Transaction.
      where(user: current_user, date: @start_date...end_date).
      where.not(category_id: Category.find_by_machine_name('transfer').id).
      order(:amount)

    render :month_breakdown
  end
end
