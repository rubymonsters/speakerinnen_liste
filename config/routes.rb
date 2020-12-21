Rails.application.routes.draw do

  # for production I have to add devise routes here
  devise_for :profiles,
              only: :omniauth_callbacks,
              controllers: {
                omniauth_callbacks: :omniauth_callbacks,
                confirmations: :confirmations,
                registrations: :registrations
              }

  scope '(:locale)', locale: /en|de/ do

    delete 'image/:id/destroy', to: 'image#destroy', as: 'image'

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
      resources :features do
        member do
          post 'announce_event'
          post 'stop_event'
        end
      end
      resources :profiles do
        resources :medialinks do
          collection { post :sort }
        end
        member do
          post 'publish'
          post 'unpublish'
          post 'admin_update'
        end
      end
      root to: 'dashboard#index'
    end

    namespace :api do
      namespace :v1 do
        resources :profiles, only: [:index, :show]
      end
    end

  # for localhost I have to add devise routes here
    devise_for :profiles,
      skip: :omniauth_callbacks,
      controllers: {
        omniauth_callbacks: :omniauth_callbacks,
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
    get 'code_of_conduct' => 'pages#code_of_conduct'

    get '/', to: 'pages#home'

    get 'categories/:category_id', to: 'profiles#index', as: :category
    # resources :categories

    get '/404', to: "errors#not_found"
    get '/422', to: "errors#unacceptable"
    get '/500', to: "errors#internal_error"

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

end
