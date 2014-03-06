SpeakerinnenListe::Application.routes.draw do

  namespace :admin do
    resources :tags, :except => [:new, :create]
    resources :profiles do
      resources :medialinks
      member do
        post "publish"
        post "unpublish"
      end
    end
    root to: 'dashboard#index'
  end

  scope "(:locale)", :locale => /en|de/ do

    devise_for :profiles, controllers: {omniauth_callbacks: "omniauth_callbacks"}

    get 'topics/:topic', to: 'profiles#index', as: :topic

    match 'search' => 'search#search'

    get  'contact' => 'contact#new',    :as => 'contact'
    post 'contact' => 'contact#create', :as => 'contact'

    match 'impressum' => 'pages#impressum'
    match 'about' => 'pages#about'

    get '/', to: 'pages#home', as: :root

    resources :profiles, :except => [:new, :create] do
      resources :medialinks
      get  'contact' => 'contact#new',    :as => 'contact', :on => :member
      post 'contact' => 'contact#create', :as => 'contact', :on => :member
    end

    devise_scope :profile do
      get 'sign_up' => 'devise/registrations#new'
    end

    #get 'sign_up' => 'profiles#new'
  end
end
