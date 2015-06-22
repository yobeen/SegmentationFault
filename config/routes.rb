Rails.application.routes.draw do

  #get 'answers/index'

  #get 'answers/show'

 # get 'answers/new'
#
#  get 'answers/edit'

root to: "questions#index"

resources :questions do
 resources :answers
end





end
