AnAxe::Engine.routes.draw do
  root :to => "forums#index"

  #resources :topics, :controller => 'an_axe/forums/topics'
  resources :all_posts, :controller => 'an_axe/forums/posts', :only => [:index] do
    collection do
      get :search, :monitored
    end
  end
  #resources :posts, :except => [:index]

  resources :forums, :controller => 'an_axe/forums' do
    match '/' => 'forums#index', :as => 'home'
    resources :posts, :controller => 'an_axe/forums/posts', :name_prefix => "forum_"

    resources :topics, :controller => 'an_axe/forums/topics' do
      resources :posts, :controller => 'an_axe/forums/posts' do
        resource :monitorship, :only => [:create, :destroy], :controller => 'an_axe/forums/monitorships'
      end
    end
  end

end
