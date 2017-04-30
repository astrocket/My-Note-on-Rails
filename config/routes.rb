Rails.application.routes.draw do
  resources :posts
end

=begin
Rails.application.routes.draw do
  get 'posts/index'
  get 'posts/new'
  get 'posts/create'
  get 'posts/show'
  get 'posts/edit'
  get 'posts/update'
  get 'posts/destroy'
end
=end

=begin
Rails.application.routes.draw do
  get 'posts/index'
  get 'posts/new'
  post 'posts/create/:id' => 'posts#create'
  get 'posts/show/:id' => 'posts#show'
  get 'posts/edit/:id' => 'posts#edit'
  patch 'posts/update/:id' => 'posts/update'
  delete 'posts/destroy/:id' => 'posts/destroy'
end
=end