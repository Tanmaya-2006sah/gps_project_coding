Rails.application.routes.draw do
  devise_for :caretakers, controllers: {
    sessions: "caretakers/sessions",
    registrations: "caretakers/registrations"
  }
  devise_for :users
  root "dashboard#index"

  # Caretaker routes
  namespace :caretakers do
    root "dashboard#index"
    get "dashboard", to: "dashboard#index"

    resources :patients, only: [ :index, :show ] do
      member do
        get :vitals_chart_data
        patch :update_assignment
        delete :remove_assignment
        get :live_data, to: "dashboard#live_patient_data"
      end
    end

    # API endpoints for caretaker dashboard
    get "vitals_chart/:patient_id", to: "dashboard#patient_vitals_chart", as: :patient_vitals_chart
  end

  # Dashboard
  get "dashboard", to: "dashboard#index"

  # RESTful resources
  resources :patients do
    resources :geofence_zones, except: [ :index ]
  end

  resources :geofence_zones, only: [ :index ]

  resources :notifications, only: [ :index, :show ] do
    member do
      patch :mark_as_read
    end
  end

  # Profile routes
  resource :profile, only: [ :show, :edit, :update ]

  # API routes for real-time updates
  namespace :api do
    namespace :v1 do
      resources :patients, only: [ :show ] do
        member do
          get :location
          get :vital_signs
          get :activities
        end

        collection do
          get :locations  # GET /api/v1/patients/locations - all patient locations
        end
      end

      resources :notifications, only: [ :index ]

      # Live monitoring endpoints
      get "vitals/latest", to: "vitals#latest"  # GET /api/v1/vitals/latest - all latest vitals
      get "dashboard/stats", to: "dashboard#stats"  # GET /api/v1/dashboard/stats - dashboard statistics
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
