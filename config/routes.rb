Rails.application.routes.draw do
  root 'static#home'

  # If not signin -> /
  # Else -> /dashboard

  # get 'signup' => 'users#new'

  # scope ':github_user/:repo' do
  #   resources :reviews, only: [:index]
  # end

  resources :reviews, only: [:show]

  post 'reviews' => "reviews#create"
end

## GET /:github_user/:repo/reviews
# Show all checks for the given user & repo.
#-----------------------------
#       |<:pr> <status>| <- clickable
#       |<:pr> <status>|
#       |<:pr> <status>|
#       |              |
#       |              |
#       |              |
#-----------------------------
