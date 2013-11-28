class ImportDataController < ApplicationController
  def upload_csv
  end

  def process_csv
    render text: params[:csv_data].read
  end

  def upload_statement
  end
end
