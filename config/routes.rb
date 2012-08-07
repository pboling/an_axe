AnAxe::Engine.routes.draw do

  #resources :topics, :controller => 'forums/topics'
  resources :all_posts, :controller => 'forums/posts', :only => [:index] do
    collection do
      get :search, :monitored
    end
  end
  #resources :posts, :except => [:index]

  resources :forums, :controller => 'forums' do
    match '/' => 'forums#index', :as => 'home'
    resources :posts, :controller => 'forums/posts', :name_prefix => "forum_"

    resources :topics, :controller => 'forums/topics' do
      resources :posts, :controller => 'forums/posts' do
        resource :monitorship, :only => [:create, :destroy], :controller => 'forums/monitorships'
      end
    end
  end

end
