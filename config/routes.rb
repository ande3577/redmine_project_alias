# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

get '/projects/:project_id/aliases/new', :to => 'aliases#new' 
post '/projects/:project_id/aliases/create', :to => 'aliases#create'