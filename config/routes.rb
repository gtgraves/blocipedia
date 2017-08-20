Rails.application.routes.draw do
  resources :wikis do
    resources :collaborators, only: [:new, :create, :destroy]
  end
  resources :charges, only: [:new, :create]


  devise_for :users

  post 'users/downgrade' => 'users#downgrade', as: :downgrade

  root 'welcome#index'
end
