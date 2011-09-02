Rails.application.routes.draw do |map|  # NOT MyEngineName::Engine.routes.draw

  resources :posts
  resources :topics
  resources :posts, :name_prefix => 'all_' do
    collection do
      get :search, :monitored
    end
  end

  resources :forums do
    match '/' => 'forums#index', :as => 'forum_home'
    scope ":forum_id" do
      resources :posts, :name_prefix => "forum_"
    end

    resources :topics do
      resources :posts do
        resource :monitorship, :only => [:create, :destroy], :controller => 'monitorships'
      end
    end
  end

end
