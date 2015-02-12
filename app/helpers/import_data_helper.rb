require 'csv'

module ImportDataHelper
  STATEMENT_COLUMNS = {
    'chase' => [ :transaction_type, :date, :other_date, :description, :amount ],
    'old-citi' => [ :date, :amount, :description, :unknown ],
    'citi' => [ :status, :date, :description, :amount, :amount_credited ],
    'dcu' => [ :transaction_number, :date, :description, :memo, :amount, :amount_credited ],
    'ing' => [ :bank_id, :account_number, :account_type, :balance, :start_date,
      :end_date, :transaction_type, :date, :amount, :id, :description ]
  }

  N_HEADERS = {
    'chase'     => 1,
    'old-citi'  => 0,
    'citi'      => 1,
    'dcu'       => 4,
    'ing'       => 1,
  }

  def self.column_index(bank, column)
    STATEMENT_COLUMNS[bank].index(column)
  end

  def self.parse_statement(bank, data, user, category)
    delimiter = (bank == 'old-citi' ? '|' : ',')
    sign = (bank == 'old-citi' ? -1 : 1)
    n_headers = N_HEADERS[bank]

    CSV.parse(data, :col_sep => delimiter)[n_headers..-1].map do |line|
      if line.length < 3
        next
      end

      if bank == 'dcu' and line[column_index(bank, :amount)] == nil
        line[column_index(bank, :amount)] = line[column_index(bank, :amount_credited)]
      elsif bank == 'citi'
        if line[column_index(bank, :amount)].empty?
          line[column_index(bank, :amount)] = line[column_index(bank, :amount_credited)]
        elsif
          line[column_index(bank, :amount)] = "-" + line[column_index(bank, :amount)]
        end
      end

      {
        date: Date.parse(line[column_index(bank, :date)]),
        description: line[column_index(bank, :description) ].strip().gsub('"',''),
        amount: line[column_index(bank, :amount)].gsub('$','').gsub(',','').to_f*sign,
        category: category,
        user: user
      }
    end
  end

  def self.import_statement(bank, data, user)
    category = Category.find_or_create_by(name: 'Uncategorized', user: user)

    parse_statement(bank, data, user, category).each do |transaction|
      Rails.logger.info "Creating transaction: #{transaction}"
      Transaction.create transaction
    end
  end
end
