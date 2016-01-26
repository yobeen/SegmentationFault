Rails.application.routes.draw do
  devise_for :users
  root to: "questions#index"

  resources :questions do
    member do
      patch 'upvote', to: 'questions#upvote'
      patch 'downvote', to: 'questions#downvote'
      patch 'unvote', to: 'questions#unvote'
    end

    resources :answers do
	   member do
		  patch 'accept'
      patch 'upvote', to: 'answers#upvote'
      patch 'downvote', to: 'answers#downvote'
      patch 'unvote', to: 'answers#unvote'
     end
   end
  end
end
