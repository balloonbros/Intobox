Intobox::Application.routes.draw do
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'
  root 'welcome#index'

  get '/privacy_policy' => 'welcome#privacy_policy'
  get '/terms_of_service' => 'welcome#terms_of_service'

  get '/auth/facebook/callback' => 'session#facebook'
  get '/auth/dropbox_oauth2/callback' => 'session#dropbox_oauth2'

  get '/home' => 'home#index'
  get '/signout' => 'session#signout'

  resources :transfers, only: [ :create ]

  namespace :facebook do
    get '/subscription' => 'subscriptions#new'
    post '/subscription' => 'subscriptions#listen'
  end

  resources :users, only: [ :destroy ] do
    get 'delete', on: :member
  end

  resources :transfer_histories, only: [ ] do
    collection do
      get 'receive'
      get 'send' => 'transfer_histories#send_to'
    end
  end

  get '*path' => 'application#render_404' if Rails.env.production?
end
