VinsolCampusHiringApp::Application.routes.draw do

  devise_for :users, controllers: { registrations: 'registrations' }
  get 'user', to: 'users#show', as: 'user'
  root to: 'application#index'
  namespace :admin do
    resources  :questions, except: :new
    resources :mcqs, :subjectives, controller: 'questions'
    get 'questions/:question_type/new', to: 'questions#new', as: 'new_question'
    resources :categories do
      get 'questions', on: :member
    end
    resources :difficulty_levels do
      get 'questions', on: :member
    end
    resources :quizzes do
      member do
        get 'show_results'
        post 'export_results_to_csv'
        get 'choose_questions'
        get 'show_questions'
        get 'update_questions'
        get 'add_questions_automatically'
        get 'remove_question'
        get 'email_results'
      end
        get 'results', on: :collection
    end
    get 'quiz/:quiz_id/user/:user_id/responses', to: 'responses#show_user_quiz_responses', as: 'responses'
    root to: 'dashboard#show'
  end

  scope module: 'admin' do
    resources :admins, except: :show
    get 'admin/home', to: 'admins#show', as: 'admin_home'
    get 'admin/manage_questions', to: 'questions#index', as: 'manage_questions'
    get 'admin/manage_categories', to: 'categories#index', as: 'manage_categories'
    get 'admin/manage_difficulty_levels', to: 'difficulty_levels#index', as: 'manage_difficulty_levels'
    get 'admin/manage_quizzes', to: 'quizzes#index', as: 'manage_quizzes'
    get 'auth/:provider/callback', to: 'sessions#create'
    get 'auth/failure', to: redirect('/admin')
    post 'logout', to: 'sessions#destroy', as: 'logout'
    resources :sessions, only: [:create, :destroy]
  end
    get 'auth/google_oauth2', as: 'google_login'
    get 'quiz/:code', to: 'quizzes#show', as: 'quiz'
    post 'quiz/:code/check_passcode', to: 'quizzes#check_passcode', as: 'validate_passcode'
    get 'quiz/:code/show_instructions', to: 'quizzes#show_instructions', as: 'instructions'
    get 'quiz/:code/show_questions', to: 'quizzes#show_questions', as: 'show_questions'
    get 'next_question', to: 'quizzes#next_question', as: 'next_question'
    get 'finish_quiz', to: 'quizzes#finish_quiz', as: 'finish_quiz'
    get 'update_timer', to: 'quizzes#update_timer', as: 'update_timer'
    # get 'quiz/:code/*other', to: 'quizzes#show'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
