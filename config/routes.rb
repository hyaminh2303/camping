Rails.application.routes.draw do

  mount Ckeditor::Engine => '/ckeditor'
  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    namespace :admin do
      resources :admin_users
      scope 'supplier/:supplier_company_type' do
        resources :supplier_companies do
          get :show
        end
      end

      resource :glover_company
      resources :child_and_pet_settings
      resources :blogs
      resources :blog_categories, path: "blog_categories/:category_type"
      resources :camp_category_groups
      resources :camp_categories
      resources :camp_types
      resources :camp_car_categories
      resources :classification_day_settings
      resources :recommended_camp_items, path: "recommended_camp_items/:item_type"
      resources :date_settings, only: [ :index, :create, :update] do
        collection do
          post :create_or_update_by_day_of_week
        end
      end
      resources :camp_cars
      resources :campsites do
        collection do
          post :reload_child_and_pet_entrance_fees_form
        end

        resources :campsite_plans
      end
      resources :campsite_plans do
        collection do
          post :camsite_default_fee
          post :reload_child_and_pet_fees_form
        end
      end
      resource :autocomplete do
      end
      resources :campsite_plan_options
      resources :camp_car_options
      resources :campsite_bookings, only: [:index, :new, :create, :show, :edit, :update] do
        member do
          patch :add_note
        end
        collection do
          get :add_note_form
          post :check_remaining_quantity
          match :calculate_price, via: [:post, :patch]
        end
      end
      resources :camp_car_bookings, only: [:index, :show, :edit, :update] do
        member do
          patch :calculate_price
          patch :add_note
        end
        collection do
          get :add_note_form
        end
      end
      resources :slider_banners
      resources :contact_us, only: [:index, :show]

      resources :travel_packages, only: [] do
        member do
          patch :update_status
          delete :cancel
        end
      end
      resources :notices, path: 'notices/:item_type'
      resources :customer_user_managements, only: [:index]
      resources :campsite_sale_managements, only: [:index]
      resources :camp_car_sale_managements, only: [:index]
      resources :booking_messages, only: [:update]
      resources :states, only: [:index, :edit, :update]

      resources :deepl_translations do
        collection do
          post :translate
        end
      end

      root  to: 'admin_users#index',
            constraints: RoleConstraint.new(:super_admin),
            as: :root


      root  to: 'supplier_companies#show',
            constraints: RoleConstraint.new(:camp_car_admin),
            as: :camp_car_root,
            supplier_company_type: 'camp_car_supplier_company'

      root  to: 'supplier_companies#show',
            constraints: RoleConstraint.new(:campsite_admin),
            as: :campsite_root,
            supplier_company_type: 'campsite_supplier_company'
    end

    devise_for :admin_users
    devise_for :customer_users, controllers: { sessions: 'customer_users/sessions', registrations: 'customer_users/registrations', passwords: 'customer_users/passwords' }
    devise_scope :customer_user do
      get "customer_users/new_email_validation",
          to: "customer_users/registrations#new_email_validation",
          as: :new_email_validation

      post "customer_users/validate_email",
          to: "customer_users/registrations#validate_email",
          as: :validate_email

      get "customer_users/email_validation",
          to: "customer_users/registrations#email_validation",
          as: :email_validation

    end

    resources :bookings, only: [:index]
    resources :campsites, only: [:index, :show] do
      collection do
        get :search
      end
    end
    resources :campsite_plans, only: [:show] do
      collection do
        post :calculate_price
        post :check_remaining_quantity
      end
    end
    resources :camp_cars, only: [:index, :show] do
      collection do
        get :search
        post :calculate_price
        post :check_remaining_quantity
      end
    end
    resources :notices, only: [:index, :show]

    namespace :checkout do
      resources :member_registrations do
        collection do
          get :new_email_validation
          post :validate_email
          get :email_verification
          get :password_for_sign_in
          post :sign_in_customer_user
        end
      end

      resources :campsite_bookings, only: [:edit] do
        member do
          match :select_people_and_date, via: [:get, :post]
        end

        collection do
          get :select_plan_options
          get :contact_information
          get :confirm_information
          post :create_booking
          post :update_booking
          post :calculate_price
          post :check_remaining_quantity
          get :thank_you
        end
      end

      resources :camp_car_bookings, only: [] do
        member do
          match :select_place_and_date, via: [:get, :post]
        end

        collection do
          get :select_car_options
          get :contact_information
          get :confirm_information
          post :create_booking
          post :update_booking
          post :calculate_price
          post :check_remaining_quantity
          get :thank_you
        end
      end

      resources :payments, only: [:new, :create] do
        collection do
          get :add_card
          get :credit_card_addition_expired
        end
      end

    end

    resources :tours
    resource :my_page, only: [:show]

    resources :travel_packages, only: [:show] do
      member do
        patch :update_status
        delete :cancel
      end
    end

    resource :contact_us, only: [:new, :create] do
      collection do
        match :confirm_information, via: [:get, :post]
        get :thanks
      end
    end
    resources :blogs, only: [:index, :show], path: "blogs/:blog_type"

    resources :privacy_policy, only: [:index]
    resources :terms_of_use, only: [:index]
    resources :booking_messages, only: [:create, :show, :update]
    resource :autocomplete do
      collection do
        get :search_free_word
      end
    end

    get 'home/booking_histories', to: 'home#booking_histories'
    get 'home/contact', to: 'home#contact'
    get 'home/contact_errors', to: 'home#contact_errors'
    get 'home/contact_confirm', to: 'home#contact_confirm'
    get 'home/contact_thanks', to: 'home#contact_thanks'
    get 'rental_cars', to: 'rental_cars#index'
    get 'rental_equipments', to: 'rental_equipments#index'
    get 'information', to: 'home#information'
  end

  root 'home#index'

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
