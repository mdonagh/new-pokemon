Rails.application.routes.draw do
  root to: "pokemon#index"
  get 'start', to: 'pokemon#start'
  post 'hit', to: 'pokemon#hit'
  post 'catch', to: 'pokemon#catch'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
