Rails.application.routes.draw do

  devise_for :profiles,
              only: :omniauth_callbacks,
              controllers: {
                omniauth_callbacks: 'omniauth_callbacks',
                confirmations: :confirmations
              }

  scope '(:locale)', locale: /en|de/ do

    namespace :admin do
      resources :tags, except: [:new, :create] do
        collection do
          get 'index'
        end
        member do
          post 'set_category'
          post 'remove_category'
          post 'set_tag_language'
          post 'remove_tag_language'
        end
      end
      resources :categories
      resources :profiles do
        resources :medialinks do
          collection { post :sort }
        end
        member do
          post 'publish'
          post 'unpublish'
          post 'admin_comment'
        end
      end
      root to: 'dashboard#index'
    end

    namespace :api do
      namespace :v1 do
        resources :profiles, only: [:index, :show]
      end
    end

    devise_for :profiles, skip: :omniauth_callbacks, controllers: {
      omniauth_callbacks: 'omniauth_callbacks',
      confirmations: :confirmations,
      registrations: :registrations
    }

    get 'topics', to: 'profiles#index', as: :topic

    get 'profiles_typeahead' => 'profiles#typeahead'

    get  'contact' => 'contact#new',    as: 'contact'
    post 'contact' => 'contact#create'

    get 'impressum' => 'pages#impressum'
    get 'privacy' => 'pages#privacy'
    get 'about' => 'pages#about'
    get 'links' => 'pages#links'
    get 'faq' => 'pages#faq'
    get 'press' => 'pages#press'

    get '/', to: 'pages#home'

    get 'categories/:category_id', to: 'profiles#index', as: :category

    resources :profiles, except: [:new, :create] do
      resources :medialinks
        get  'contact' => 'contact#new', as: 'contact', on: :member
        post 'contact' => 'contact#create', on: :member

      resources :medialinks do
       collection { post :sort }
      end
    end

    devise_scope :profile do
      get 'sign_up' => 'devise/registrations#new'
    end

    constraints(host: /^(speakerinnen-liste.herokuapp.com|speakerinnen.org)$/) do
      root to: redirect('http://www.speakerinnen.org')
    end
  end

  unless Rails.application.config.consider_all_requests_local
    # having created corresponding controller and action
    get '*path', to: 'errors#error_404', via: :all
  end
end
