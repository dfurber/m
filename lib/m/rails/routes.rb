M::Application.routes.draw do
  devise_for :users do
    match 'login' => 'devise/sessions#new', :as => 'login'
    match 'logout' => 'devise/sessions#destroy', :as => 'logout'
  end
  
  root :to => 'nodes#show'
  match 'nodes' => 'nodes#index'
  
  resources :pages

  namespace :admin do
    root :to => 'nodes#index'
    resources :keys
    resources :snippets do
      delete :remove
    end
    resources :nodes do
      collection do
        post :move
      end
      delete :remove, :on => :member
      get :toggle, :on => :member
    end
    resources :webforms

    resources :users do
      get :mask, :on => :member
      get :unmask, :on => :member
    end
    resources :roles do
      get :remove, :on => :member
    end
    match '(roles/:role_id)/permissions' => 'permissions#index', :as => 'permissions'
  end

  match '*url(.:format)' => 'nodes#show'

end
