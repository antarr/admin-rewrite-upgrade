Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # This is where the home page lives
#   map.root :controller => 'auth', :action => 'index'
  root to: 'auth#new'

  resources :auth, only: [:new, :create]
  get '/logout', controller: 'auth', action: 'logout'

  resources :getting_started, only: [:index, :create]

  resources :dashboard, only: [:index]

#   map.resources :domains, :active_scaffold => true do |domain|
#     domain.resources :users, :active_scaffold => true
#     domain.resources :forwardings, :active_scaffold => true
#   end

#   # Allow downloading Web Service WSDL as a file with an extension
#   # instead of a file named 'wsdl'
#   map.connect ':controller/service.wsdl', :action => 'wsdl'

#   map.connect ':controller/:action/:ip', :id => nil,
#     :requirements => {:ip => /\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/}

#   map.connect '/domains/:domain_id/:controller/:id/save_admin_domains', :action => 'save_admin_domains',
#     :requirements => {:domain_id => /\d+/}

#   # Install the default route as the lowest priority.
#   map.connect ':controller/:action/:id.:format'
#   map.connect ':controller/:action/:id'
end
