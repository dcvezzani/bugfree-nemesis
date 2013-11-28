Clf004::Application.routes.draw do

  match 'track/:slug' => 'projects#track', :via => :get, :as => :track_project
  resources :projects do

    match 'stories/list' => 'stories#list', :via => :get, :as => :list_stories
    resources :stories do
      resources :notes, controller: 'story_notes' do
        member do
          get 'edit_content'
          put 'update_content'
        end
      end

      resources :work_hours do
      end

      member do
        put 'update_hours'
        put 'mark_as_done'
        get 'fetch_work_hours'
      end
    end

    match 'entries/:id/trigger_work_timer' => 'entries#trigger_work_timer', :via => :put, :as => :trigger_work_timer
    match 'entries/copy_from_yesterday' => 'entries#copy_from_yesterday', :via => :get, :as => :copy_from_yesterdays_entry
    resources :entries do
      resources :notes, controller: 'entry_notes' do
        member do
          get 'edit_content'
          put 'update_content'
        end
      end

      resources :work_intervals
   
      collection do
        get 'current'
        get 'report'
      end

      member do
        post 'select_stories'
        get 'show_work_intervals'
      end

      resources :stories do
        resources :work_hours do
        end
      end

      match 'stories/:id/add_hours_worked' => 'stories#add_hours_worked', :via => :post, :as => :story_add_hours_worked
    end
  end

  get "welcome/index"
  get "welcome/wizard", as: :wizard_welcome
  get "welcome/wizard_bar", as: :wizard_bar_welcome

  devise_for :users

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'projects#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
