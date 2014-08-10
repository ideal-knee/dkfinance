class ImportDataController < ApplicationController
  before_filter :authenticate_user!

  def upload_csv
  end

  def process_csv
    params[:csv_data].read.split("\n").each do |line|
      Transaction.create_from_csv_line(line, current_user)
    end
    flash[:notice] = "CSV processed."
    redirect_to action: 'upload_csv'
  end

  def upload_statement
  end

  def process_statement
    ImportDataHelper.parse_statement(params[:bank], params[:statement_data].read, current_user)
    flash[:notice] = "#{params[:bank]} statement imported."
    redirect_to action: 'upload_statement'
  end
end
