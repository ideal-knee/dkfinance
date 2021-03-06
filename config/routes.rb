Dkfinance::Application.routes.draw do
  devise_for :users
  get "import_data/upload_csv", as: 'upload_csv'
  post "import_data/process_csv"

  get "import_data/upload_statement", as: 'upload_statement'
  post "import_data/process_statement"

  get "transactions/categorize", as: 'transactions_categorize'
  post "transactions/save_categories", as: 'transactions_save_categories'

  get "analyze/month_to_month", as: 'analyze_month_to_month'
  get "analyze/month_breakdown/all_categories/:year/:month", to: 'analyze#month_breakdown_all', as: 'analyze_month_breakdown_all'
  get "analyze/month_breakdown/:category/:year/:month", to: 'analyze#month_breakdown', as: 'analyze_month_breakdown'

  resources :transactions
  resources :categories

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
