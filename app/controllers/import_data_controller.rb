class ImportDataController < ApplicationController
  before_filter :authenticate_user!

  def upload_csv
  end

  def process_csv
    params[:csv_data].read.split("\n").each do |line|
      Transaction.create_from_csv_line(line, current_user)
    end
    redirect_to controller: 'transactions', action: 'index'
  end

  def upload_statement
  end
end
