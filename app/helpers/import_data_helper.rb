require 'csv'

module ImportDataHelper
  BANKS = [
    ['Chase', 'chase'],
    ['Citi' , 'citi' ],
    ['DCU'  , 'dcu'  ],
    ['ING'  , 'ing'  ]
  ]

  STATEMENT_COLUMNS = {
    'chase' => [ :transaction_type, :date, :other_date, :description, :amount ],
    'citi' => [ :date, :amount, :description, :unknown ],
    'dcu' => [ :transaction_number, :date, :description, :memo, :amount, :amount_credited ],
    'ing' => [ :bank_id, :account_number, :account_type, :balance, :start_date,
      :end_date, :transaction_type, :date, :amount, :id, :description ]
  }

  N_HEADERS = {
    'chase' => 1,
    'citi'  => 0,
    'dcu'   => 4,
    'ing'   => 1
  }

  def self.column_index(bank, column)
    STATEMENT_COLUMNS[bank].index(column)
  end

  def self.parse_statement(bank, data, user)
    delimiter = (bank == 'citi' ? '|' : ',')
    sign = (bank == 'citi' ? -1 : 1)
    n_headers = N_HEADERS[bank]

    CSV.parse(data, :col_sep => delimiter) do |line|
      if n_headers > 0
        n_headers -= 1
        next
      end

      if bank == 'dcu' and line[column_index(bank, :amount)] == nil
        line[column_index(bank, :amount)] = line[column_index(bank, :amount_credited)]
      end

      Rails.logger.info [
        Date.parse(line[column_index(bank, :date)]).strftime('%Y%m%d'),
        line[column_index(bank, :description) ].strip().gsub('"',''),
        line[column_index(bank, :amount)].gsub('$','').gsub(',','').to_f*sign
      ].join("\t")

      Transaction.create(
        date: Date.parse(line[column_index(bank, :date)]),
        description: line[column_index(bank, :description) ].strip().gsub('"',''),
        amount: line[column_index(bank, :amount)].gsub('$','').gsub(',','').to_f*sign,
        category: Category.first_or_create(name: 'Uncategorized'),
        user: user
      )
    end
  end
end
