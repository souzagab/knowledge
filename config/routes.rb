Rails.application.routes.draw do
  # Health
  get "ping", to: "ping#show"

  # Auth
  # TODO: Restructure devise routes, mounting only the ones necessary
  #   `devise_for` mounts all routes eg: (new, edit) that we don't use in api-mode
  devise_for :users,
    path: "",
    path_names: {
      registration: "signup",
      sign_in: "signin",
      sign_out: "signout"
    },
    controllers: {
      sessions: "sessions",
      registrations: "registrations"
    },
    defaults: { format: :json }

  resources :users

  resources :courses do
    resources :enrollments, module: :courses, only: %i[index create destroy]
    resources :contents, module: :courses, only: %i[index create show destroy]
  end

  resources :blobs, only: %i[create show]

  match "*path", to: "application#route_not_found!", via: :all
end
