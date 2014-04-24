Gtd::Application.routes.draw do
  devise_for :users, :path => '', :path_names => {:sign_in => 'login', :sign_out => 'logout'}

  concern :context do
    collection do
      resources :contexts, param: :name, only: [:show]
    end
  end

  resources :contexts, param: :name, only: [:new, :create, :edit, :update, :destroy, :index]
  resources :todos, concerns: [:context]
  match '/todos/filter/:type/:type_name', to: 'todos#filter', via: 'get'
  match '/todos/move', to: 'todos#move', via: 'post'
  match '/todos/:id/prior', to: 'todos#change_prior', via: 'patch'

  resources :projects, param: :name, only: [:show, :edit, :update, :destroy, :index]
  match '/project/:name/change_state', to: 'projects#change_state', via: 'patch'
  match '/projects/:name/filter/:type/:type_name', to: 'projects#filter', via: 'get'

  match '/about', to: 'static_pages#about', via: 'get'

  root 'todos#index'
end
