class ImportDataController < ApplicationController
  def upload_csv
  end

  def process_csv
    params[:csv_data].read.split("\n").each do |line|
      Transaction.create_from_csv_line(line)
    end
    redirect_to controller: 'transactions', action: 'index'
  end

  def upload_statement
  end
end
