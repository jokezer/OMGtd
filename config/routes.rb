Gtd::Application.routes.draw do
  devise_for :users, :path => '', :path_names => {:sign_in => 'login', :sign_out => 'logout'}

  concern :context do
    collection do
      resources :contexts, param: :name, only: [:show]
    end
  end

  resources :todos, concerns: [:context]
  resources :contexts, only: [:new, :create, :show, :edit, :update, :destroy, :index]
  resources :projects, only: [:show, :edit, :update, :destroy, :index]

  match '/about', to: 'static_pages#about', via: 'get'

  root 'todos#spa'
end
