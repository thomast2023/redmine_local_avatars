RedmineApp::Application.routes.draw do
  scope 'redmine_local_avatars' do
    match 'my/avatar', :to => 'my#avatar', :via => [:get, :post], as: :my_avatar
    match 'my/save_avatar/:id', :to => 'my#save_avatar', :via => [:get, :post]
    match 'account/get_avatar/:id', :to => 'account#get_avatar', :constraints => {:id=>/\d+/}, :via => [:get, :post]
    match 'users/save_avatar/:id', :to => 'users#save_avatar', :constraints => {:id=>/\d+/}, :via => [:get, :post]
    match 'users/get_avatar/:id', :to => 'users#get_avatar', :constraints => {:id=>/\d+/}, :via => [:get, :post]
  end
end