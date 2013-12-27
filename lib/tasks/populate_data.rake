namespace :populate_data do
  desc "Create fake data for development"
  task dev: [:environment] do
    categories = %w{
      Commuting
      Entertainment
      Food
      Medical
      Travel
    }
    10.times do
      puts rand(1.year).ago
    end
  end
end
