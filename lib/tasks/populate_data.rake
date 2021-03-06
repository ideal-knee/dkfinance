begin
  require 'faker'

  namespace :populate_data do
    desc "BLOW AWAY EXISTING DATA and create fake data for development"
    task dev: [:environment] do
      Category.destroy_all
      Transaction.destroy_all
      User.destroy_all

      user = User.find_or_create_by(email: 'asdf@fdsa.com')
      user.password = 'asdffdsa'
      user.save!

      categories = %w{
        Commuting
        Entertainment
        Food
        Medical
        Paycheck
        Travel
      }

      companies = []
      100.times do
        companies << { name: Faker::Company.name, category: categories.sample }
      end

      1000.times do
        company = companies.sample
        Transaction.create(
          description: company[:name],
          amount: (rand * 100).round(2) * (company[:category] == 'Paycheck' ? 10 : -1),
          date: rand(1.year).ago,
          category: Category.find_or_create_by(name: (rand < 0.1 ? 'Uncategorized' : company[:category]), user: user),
          user: user
        )
      end
    end
  end
rescue LoadError
end
