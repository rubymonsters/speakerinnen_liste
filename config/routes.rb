SpeakerinnenListe::Application.routes.draw do

  namespace :admin do
    resources :tags, :except => [:new, :create]
    resources :profiles
    root to: 'dashboard#index'
  end

  scope "(:locale)", :locale => /en|de/ do

    devise_for :profiles, controllers: {omniauth_callbacks: "omniauth_callbacks"}

    get 'topics/:topic', to: 'profiles#index', as: :topic

    match 'search' => 'search#search'

    get  'contact' => 'contact#new',    :as => 'contact'
    post 'contact' => 'contact#create', :as => 'contact'

    match 'impressum' => 'home#impressum'

    get '/', to: 'dashboard#index', as: :root

    resources :profiles, :except => [:new, :create] do
      get  'contact' => 'contact#new',    :as => 'contact', :on => :member
      post 'contact' => 'contact#create', :as => 'contact', :on => :member 
    end

    get 'sign_up' => 'pages#sign_up'
  end
end
