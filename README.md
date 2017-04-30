# 나만의 메모 만들기

5기 여러분 안녕하세요, 그동안 배웠던 CRUD 를 총 복습하면서 나만의 이쁜 메모장을 만들어 보도록해요.

언제 어디서나 손쉽게 접근 가능하고, 쓸 수 있는 메모장 입니다.

가장먼저 C9.io 에 접속해서 프로젝트를 생성합니다.



## 글 작성에 필요한 컨트롤러와 모델 만들기

1. 컨트롤러 ( 여러개의 post 를 관리하기 위한 컨트롤러이므로 posts 로 s 를 붙여서 써줍니다. )

   ```bash
   rails g controller posts index new create show edit update destroy
   ```
   ​

2. 모델

   ```bash
   rails g model post title:string content:text writer:string

   rake db:migrate
   ```

자 이제 post 를 쓰고 저장하고 편집하고 삭제하는 로직이 들어가는 컨트롤러와

post 를 저장하는 모델이 생성 되었습니다. 



3. 라우팅

   버튼 클릭 혹은 직접 도메인 타이핑으로 post 와 관련 된 액션을 취할 때 어떤경로를 누구에게 연결시켜 줄지를 설정해주어야 하는데, 이 작업을 config/routes.rb 파일에서 해주어야 합니다.

   ​

   아래와 같은 파일을 

   > config/routes.rb

   ```ruby
   Rails.application.routes.draw do
     get 'posts/index'
     get 'posts/new'
     get 'posts/create'
     get 'posts/show'
     get 'posts/edit'
     get 'posts/update'
     get 'posts/destroy'
   end
   ```

   ​

   아래처럼 수정 해줍니다.

   > config/routes.rb

   ```ruby
   Rails.application.routes.draw do
     get 'posts/index'
     get 'posts/new'
     post 'posts/create/:id' => 'posts#create'
     get 'posts/show/:id' => 'posts#show'
     get 'posts/edit/:id' => 'posts#edit'
     patch 'posts/update/:id' => 'posts/update'
     delete 'posts/destroy/:id' => 'posts/destroy'
   end
   ```

   - create 와 는 데이터를 보내므로 -> POST 방식의 http method
   - index 와 new, show, edit 는 값을 요청하고 받아오므로 -> GET 방식의 http method

   ​	- http 설명 : http://soul0.tistory.com/185

   - update 는 데이터의 일부분을 수정하므로 PATCH 방식으로 보내준다. PUT 이라는 유사한 방식이 있는데, 일부분도 업데이트 가능한 PATCH 와 다르게 PUT은 항상 전체를 업데이트 하므로 Rails 에서는 PATCH 가 선호 된다.

   ​	- put/patch 설명 : https://prsanjay.wordpress.com/2015/10/11/patch-vs-put-in-rails/

   - destroy 는 삭제하는 것이므로, 삭제용으로 만들어진 DELETE 방식의 http method

   자 그런데 이 과정은 엄청나게 많은 곳에서 반복되고, 루비 온 레일즈에서는 반복되는 부분들에 대해서 자체적으로 기능화 시켜 놓는 것이 특징 입니다.

   ​

   #### 아래 처럼 수정하면 단 한 줄 로도 동일한 기능을 구현할 수 있습니다.

   > config/routes.rb

   ```ruby
   Rails.application.routes.draw do
     resources :posts
   end
   ```

   | HTTP Verb | Path            | Controller#Action | Used for                                 |
   | --------- | --------------- | ----------------- | ---------------------------------------- |
   | GET       | /posts          | posts#index       | display a list of all posts              |
   | GET       | /posts/new      | posts#new         | return an HTML form for creating a new post |
   | POST      | /posts          | posts#create      | create a new post                        |
   | GET       | /posts/:id      | posts#show        | display a specific post                  |
   | GET       | /posts/:id/edit | posts#edit        | return an HTML form for editing a post   |
   | PATCH/PUT | /posts/:id      | posts#update      | update a specific post                   |
   | DELETE    | /posts/:id      | posts#destroy     | delete a specific post                   |



## 디자인 준비작업

이번에는 새로운 CSS/HTML 프레임워크로 디자인을 해보겠습니다.

마테리얼라이즈 : http://materializecss.com/getting-started.html

에 들어가서 CDN 을 긁어서 아래처럼 붙여넣기 해 줍니다.



> app/views/layouts/application.html.erb

```erb
<!DOCTYPE html>
<html>
<head>
  <title>Workspace</title>
  <%= stylesheet_link_tag    'application', media: 'all', 'data-turbolinks-track' => true %>
  <%= javascript_include_tag 'application', 'data-turbolinks-track' => true %>
  <%= csrf_meta_tags %>
  <!-- Compiled and minified CSS -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/materialize/0.98.2/css/materialize.min.css">
  <!-- Compiled and minified JavaScript -->
  <script src="https://cdnjs.cloudflare.com/ajax/libs/materialize/0.98.2/js/materialize.min.js"></script>
</head>
<body>

<%= yield %>

</body>
</html>

```



## posts#index

posts 컨트롤러의 index 액션은 Post 모델에 있는 모든 글 을 꺼내서 뿌려주는 로직을 수행해야 합니다.

Post 모델에서 모든 글 을 꺼내기 위해서

```ruby
Post.all
```

과 같은 접근을 할 수 있습니다. 그냥 다 꺼낸다는 말 입니다. 다 꺼낸 것들을 어디엔가 담아서 해당 뷰 로 뿌려주어야 합니다.

```ruby
@posts = Post.all
```

이렇게 앞에 @ 이 붙은 변수에 담아주게 되면 해당 뷰 ( 여기서는 views/posts/index.html.erb ) 에서 해당 변수에 접근할 수 있습니다.

- 별다른 방향을 제시해주지 않고 끝나면 항상 액션과 같은 이름의 뷰 로 뿌려지게 됩니다.



> app/controllers/posts_controller.rb

```ruby
class PostsController < ApplicationController
  def index
    @posts = Post.all
  end

  def new
  end

  def create
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
```

이제 해당 액션의 뷰 파일로가서 뷰를 만들어 보겠습니다.



> app/views/posts/index.html.erb

```ruby
<h1>Posts#index</h1>
<p>Find me in app/views/posts/index.html.erb</p>
```

일단 다 지우고 생각을 잠깐 해봅니다.



> app/views/posts/index.html.erb

```ruby

```

지금 이곳에는 @posts 가 넘어 온 상태 입니다.

@posts 안에는 컨트롤러에서 꺼내온 아직은 없지만, 곧 있게 될 수 많은 글들이 모두 담겨 있습니다. Active Record Collection 이라는 레일즈만의 방식으로 모델의 객체들이 쭈루룩 담겨 있는.. 배열이 아니지만 일종의 배열 같은 느낌이라고 생각하시면 됩니다.

이것들을 하나 하나 꺼내가면서 우리가 원하는 모양으로 가공하고, 나열해야 합니다.

하나 하나 꺼내기 위해서는 이 Active Record Collection 이라는 글 뭉치를 돌려가면서 한 녀석, 한 녀석 씩 만나고 또 그 때마다 내가 원하는 가공 작업에 들어가야 합니다. 이 때 사용하는 것이 루비의 each do 문법 입니다.

아래 처럼 html.erb 파일 속에서 루비 코드를 작성하기 위해서 <%= %> 구문 속에 루비 코드를 작성 해주어야하며, 출력이 필요없는 @posts.each do |post| 부분과 반복분의 종결을 의미하는 end 부분에 한해서는 = 기호를 제거한 <% %> 로 감싸주어야 합니다.



> app/views/posts/index.html.erb

```erb
<% @posts.each do |post| %>
    <%= post.title %>
    <%= post.content %>
    <%= post.writer %>
<% end %>
```

자, 위에 처럼 하게 되면 Active Record Collection 에 담긴 수 많은 글 들을 한 녀석 씩 마주치면서 그 녀석의 title, content, writer 를 꺼내오고 html에 출력하게 됩니다.

이제 뿌려지는 데이터를 디자인 속에 녹여야 합니다.

매번 게시판은 식상하니까 카드형태로 게시글을 나열해보겠습니다.



> 카드 : http://materializecss.com/cards.html

```html
<div class="row">
  <div class="col s12 m6">
    <div class="card white darken-1">
      <div class="card-content dark-text">
        <span class="card-title">Card Title</span>
        <p>I am a very simple card. I am good at containing small bits of information.
          I am convenient because I require little markup to use effectively.</p>
      </div>
      <div class="card-action">
        <a href="#">This is a link</a>
        <a href="#">This is a link</a>
      </div>
    </div>
  </div>
</div>
```

원래 사이트에 있던 어두운 색은 싫어서 흰색 배경에 검은 글씨로 바꾸어 보았습니다. 

자 이제 이걸 반복문에서 돌려야 합니다. 한 가지 주의 할 점은, <div class="row"> </div> 안쪽의 것들이 실질적인 카드 이므로 안쪽의 것들을 돌리고 row 는 반복문의 밖으로 빼야한다는 점 입니다.



> app/views/posts/index.html.erb

```erb
<% @posts.each do |post| %>
    <div class="row">
      <div class="col s12 m6">
        <div class="card white darken-1">
          <div class="card-content dark-text">
            <span class="card-title"><%= post.title %></span>
            <p><%= post.writer %></p>
          </div>
          <div class="card-action">
            <a href="#">글보기</a>
          </div>
        </div>
      </div>
    </div>
<% end %>
```

뭔가 내용까지 다 보여주기는 싫어서 index 에서는 제목과 글쓴이만 보여주고 버튼을 눌러야만 글을 볼 수 있도록 했습니다.



## posts#new

posts 컨트롤러의 new 액션은 새 글 을 쓰기위한 준비를 해주는 로직을 수행해야 합니다.

새글을 쓰기 위한 그릇 객체를 만들기 위해서

```ruby
Post.new
```

와 같은 접근을 할 수 있습니다. 이 녀석도 어딘가에 담아서 뷰에 넘겨주어야 하므로,

```ruby
@post = Post.new
```

처럼 써줍니다.



> app/controllers/posts_controller.rb

```ruby
class PostsController < ApplicationController
  def index
    @posts = Post.all
  end

  def new
    @post = Post.new
  end

  def create
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
```

이제 해당 액션의 뷰 파일로가서 뷰를 만들어 보겠습니다.



> app/views/posts/new.html.erb

```ruby
<h1>Posts#new</h1>
<p>Find me in app/views/posts/new.html.erb</p>
```

일단 다 지우고 생각을 잠깐 해봅니다.



> app/views/posts/new.html.erb

```ruby

```

지금 이곳에는 @post 가 넘어 온 상태 입니다. 이녀석은 index 에서 뿌려주던 @posts ( Active Record Collection ) 속의 글들과 다르게 아무 title 도 content 도 writer 도 담겨있지 않은 빈 껍데기와 같은 녀석 입니다. 이 녀석에게 값을 저장시키기 위해서는 form 이 필요 합니다. form 을 통해서 사용자로부터 원하는 값을 입력 받고 그 값들을 어떤 방식으로 보내며, 어떤 컨트롤러의 어떤 액션으로 보낼 지를 정해주어야 합니다.



> app/views/posts/new.html.erb

```erb
<form action="/posts/create/<%= @post.id %>" method='POST'>

</form>
```

위에 처럼 form 을 만들게 되면 posts 컨트롤러의 create 액션으로 id 을 함께 보내게 됩니다. http 방식은 라우팅에서 정의한대로 POST 방식 입니다.

이제 안에 채워 넣을 폼 요소들을 가져 옵니다.

> 폼 요소 : http://materializecss.com/forms.html / http://materializecss.com/buttons.html
>
> app/views/posts/new.html.erb

```erb
<form action="/posts/create/<%= @post.id %>" method='POST'>
    <div class="input-field col s12">
        <input id="title" type="text">
        <label for="title">제목</label>
    </div>
    <div class="input-field col s12">
        <input id="writer" type="text">
        <label for="writer">글쓴이</label>
    </div>
    <div class="input-field col s12">
        <textarea id="textarea1" class="materialize-textarea"></textarea>
        <label for="textarea1">내용</label>
    </div>
    <button class="btn waves-effect waves-light right" type="submit" name="action">글쓰기
    </button>
</form>
```

이제 까지 이렇게 했었습니다. 이렇게 해놓고 폼을 보면 잘 보입니다. 

한번 내용을 채워넣고 보내기를 눌러보면, 

Routing Error

No route matches [POST] "/posts/create"

| Helper                                   | HTTP Verb | Path                      | Controller#Action |
| ---------------------------------------- | --------- | ------------------------- | ----------------- |
| [Path](https://my-note-astrocket.c9users.io/posts/create/#) / [Url](https://my-note-astrocket.c9users.io/posts/create/#) |           |                           |                   |
| posts_path                               | GET       | /posts(.:format)          | posts#index       |
|                                          | POST      | /posts(.:format)          | posts#create      |
| new_post_path                            | GET       | /posts/new(.:format)      | posts#new         |
| edit_post_path                           | GET       | /posts/:id/edit(.:format) | posts#edit        |
| post_path                                | GET       | /posts/:id(.:format)      | posts#show        |
|                                          | PATCH     | /posts/:id(.:format)      | posts#update      |
|                                          | PUT       | /posts/:id(.:format)      | posts#update      |
|                                          | DELETE    | /posts/:id(.:format)      | posts#destroy     |

와 같은 에러가 나옵니다. 이런 에러가 나오는 이유는 그동안은 우리가 create 의 라우팅을 할 때 

> config/routes.rb

```ruby
post 'posts/create/:id' => 'posts#create'
```

처럼 해놓고 써오다가

> config/routes.rb

```ruby
Rails.application.routes.draw do
  resources :posts
end
```

와 같은 방법으로 라우팅을 바꿔버렸기 때문에 조금 다르게 create 액션이 행해지는 것을 알 수 있습니다. 에러 결과에서 볼 수 있듯이 더 이상은 create 액션이 posts/create/:id 경로를 타고 행해지는게 아니라 /posts(.:format) 로 행해지는 것을 알 수 있습니다.

즉 index 액션으로 가는 /posts 와 주소가 같지만 http method 가 GET 이 아닌 POST 라면 자동으로 create 액션으로 가지는 것을 알 수 있습니다. 그러므로 해당 폼의 주소도 바뀌어야 합니다.

> app/views/posts/new.html.erb

```erb
<form action="/posts/<%= @post.id %>" method='POST'>
    <div class="input-field col s12">
        <input id="title" type="text">
        <label for="title">제목</label>
    </div>
    <div class="input-field col s12">
        <input id="writer" type="text">
        <label for="writer">글쓴이</label>
    </div>
    <div class="input-field col s12">
        <textarea id="textarea1" class="materialize-textarea"></textarea>
        <label for="textarea1">내용</label>
    </div>
    <button class="btn waves-effect waves-light right" type="submit" name="action">글쓰기
    </button>
</form>
```



ActionController::InvalidAuthenticityToken 에러가 납니다.

레일즈에서는 [Cross-site request forgery, CSRF](http://blog.bigbinary.com/2012/05/10/csrf-and-rails.html) 를 방지하기 위해서 자체적으로 Token을 발급하고 확인하는 작업을 해주게 되는데, 우리가 수기로 만든 form 에는 해당 Token 이 없기 때문에 생기는 에러입니다.

아래처럼 한줄의 코드를 통해 Token 을 추가시킬 수 있습니다.

> app/views/posts/new.html.erb

```erb
<form action="/posts/<%= @post.id %>" method='POST'>
  <%= hidden_field_tag :authenticity_token, form_authenticity_token %>
    <div class="input-field col s12">
        <input id="title" type="text">
        <label for="title">제목</label>
    </div>
    <div class="input-field col s12">
        <input id="writer" type="text">
        <label for="writer">글쓴이</label>
    </div>
    <div class="input-field col s12">
        <textarea id="textarea1" class="materialize-textarea"></textarea>
        <label for="textarea1">내용</label>
    </div>
    <button class="btn waves-effect waves-light right" type="submit" name="action">글쓰기
    </button>
</form>
```

자, 이제 다 저장하고 form 을 채운 후 제출 버튼을 누르면 제출이 잘 됩니다.

그리고 form 과 함께 title, writer, textarea 를 넘길 때 구분을 지어주기 위해서 name 속성을 부여해줍니다.

> app/views/posts/new.html.erb

```erb
<form action="/posts/<%= @post.id %>" method='POST'>
    <%= hidden_field_tag :authenticity_token, form_authenticity_token %>
    <div class="input-field col s12">
        <input name="title" id="title" type="text">
        <label for="title">제목</label>
    </div>
    <div class="input-field col s12">
        <input name="writer" id="writer" type="text">
        <label for="writer">글쓴이</label>
    </div>
    <div class="input-field col s12">
        <textarea name="content" id="textarea1" class="materialize-textarea"></textarea>
        <label for="textarea1">내용</label>
    </div>
    <button class="btn waves-effect waves-light right" type="submit" name="action">글쓰기
    </button>
</form>
```



#### 아래 처럼 레일즈의 헬퍼를 사용해서 수정하면 더 쉽게 동일한 기능을 구현할 수 있습니다

> app/views/posts/new.html.erb
>
> 폼 헬퍼 : http://guides.rubyonrails.org/form_helpers.html

```erb
<%= form_for(@post, url: posts_path) do |f| %>
    <div class="input-field col s12">
      <%= f.label :title %><br>
      <%= f.text_field :title, :required => true, placeholder: '제목' %>
    </div>
    <div class="input-field col s12">
      <%= f.label :writer %><br>
      <%= f.text_field :writer, :required => true, placeholder: '글쓴이' %>
    </div>
    <div class="input-field col s12">
      <%= f.label :content %><br>
      <%= f.text_area :content, class: 'materialize-textarea' %>
    </div>
    <%= f.submit '글쓰기', class: 'btn waves-effect waves-light right' %>
<% end %>
```

| Helper                                   | HTTP Verb | Path                      | Controller#Action |
| ---------------------------------------- | --------- | ------------------------- | ----------------- |
| [Path](https://my-note-astrocket.c9users.io/posts/create/#) / [Url](https://my-note-astrocket.c9users.io/posts/create/#) |           |                           |                   |
| posts_path                               | GET       | /posts(.:format)          | posts#index       |
|                                          | POST      | /posts(.:format)          | posts#create      |
| new_post_path                            | GET       | /posts/new(.:format)      | posts#new         |
| edit_post_path                           | GET       | /posts/:id/edit(.:format) | posts#edit        |
| post_path                                | GET       | /posts/:id(.:format)      | posts#show        |
|                                          | PATCH     | /posts/:id(.:format)      | posts#update      |
|                                          | PUT       | /posts/:id(.:format)      | posts#update      |
|                                          | DELETE    | /posts/:id(.:format)      | posts#destroy     |

- form_for 는 기본적으로 POST 방식의 http method 로 전송됩니다. 그러므로 일반 폼처럼 method 설정 없이 url: posts_path 만 해주어도 알아서 create 액션으로 가게 되는 겁니다.



## posts/create

posts 컨트롤러의 create 액션은 new 에서 form 을 통해 날아온 데이터를 저장 해주는 로직을 수행해야 합니다.

- form_for 를 쓰지 않은 form 에서 날아오는 데이터를 create 액션에서 접근하는 방법

  ```ruby
  params[:title]
  params[:writer]
  params[:content]
  ```

  ​

- form_for 를 쓴 form 에서 날아오는 데이터를 create 액션에서 접근하는 방법

  ```ruby
  params[:post][:title]
  params[:post][:writer]
  params[:post][:content]
  ```

form_for 를 사용 한 것을 기준으로 로직을 써보면,

> app/controllers/posts_controller.rb

```ruby
class PostsController < ApplicationController
  def index
    @posts = Post.all
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new
    @post.title = params[:post][:title]
    @post.writer = params[:post][:writer]
    @post.content = params[:post][:content]
    @post.save
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
```



## posts#show

posts 컨트롤러의 show 액션은 index 에서 선택한 post 중 하나의 상세 내용을 보여주는 로직을 수행해야 합니다.

> app/views/posts/index.html.erb

```erb
<% @posts.each do |post| %>
    <div class="row">
      <div class="col s12 m6">
        <div class="card white darken-1">
          <div class="card-content dark-text">
            <span class="card-title"><%= post.title %></span>
            <p><%= post.writer %></p>
          </div>
          <div class="card-action">
            <a href="#">글보기</a>
          </div>
        </div>
      </div>
    </div>
<% end %>
```

위와 같은 index 의 글보기 링크를 실제 그글로 연결되도록 해야 합니다.

원래 하던 방법에 의하면 라우팅은 아래와 같았으므로,

> app/config/routes.rb

```ruby
get 'posts/show/:id' => 'posts#show'
```

여기에서도 도메인에 직접 id 값을 넘기는 아래와 같은

> app/views/posts/index.html.erb

```erb
<a href="/posts/show/<%= post.id %>">글보기</a>
```

링크가 되었어야 합니다.

하지만, 이 링크를 저장하고 누르면 아래와 같은 에러가 발생합니다.

Routing Error

No route matches [GET] "/posts/show/2"

| Helper                                   | HTTP Verb | Path                      | Controller#Action |
| ---------------------------------------- | --------- | ------------------------- | ----------------- |
| [Path](https://my-note-astrocket.c9users.io/posts/create/#) / [Url](https://my-note-astrocket.c9users.io/posts/create/#) |           |                           |                   |
| posts_path                               | GET       | /posts(.:format)          | posts#index       |
|                                          | POST      | /posts(.:format)          | posts#create      |
| new_post_path                            | GET       | /posts/new(.:format)      | posts#new         |
| edit_post_path                           | GET       | /posts/:id/edit(.:format) | posts#edit        |
| post_path                                | GET       | /posts/:id(.:format)      | posts#show        |
|                                          | PATCH     | /posts/:id(.:format)      | posts#update      |
|                                          | PUT       | /posts/:id(.:format)      | posts#update      |
|                                          | DELETE    | /posts/:id(.:format)      | posts#destroy     |

이런 에러가 나오는 이유는 그동안은 우리가 show 의 라우팅을 할 때와 다른 방식의 라우팅이 

> app/config/routes.rb

```ruby
Rails.application.routes.draw do
  resources :posts
end
```

에 의해서 만들어졌기 때문입니다. /posts/:id(.:format) 라고 되어있으므로 show 부분을 자르고 다시 시도해봅니다.

>app/views/posts/index.html.erb

```erb
<a href="/posts/<%= post.id %>">글보기</a>
```

잘 됩니다.

#### 아래 처럼 레일즈의 헬퍼를 사용해서 수정하면 더 쉽게 동일한 기능을 구현할 수 있습니다

> app/views/posts/index.html.erb
>
> 링크 헬퍼 : https://apidock.com/rails/ActionView/Helpers/UrlHelper/link_to

```ruby
<%= link_to '글보기', post %>
```

여기에서 <%= link_to 링크의보여지는이름, 링크의경로가가리킬대상 %> 라고 보면 되는데, post.title 이므로 해당 글의 제목이  

> app/views/posts/index.html.erb

```erb
<% @posts.each do |post| %>
    <div class="row">
      <div class="col s12 m6">
        <div class="card white darken-1">
          <div class="card-content dark-text">
            <span class="card-title"><%= post.title %></span>
            <p><%= post.writer %></p>
          </div>
          <div class="card-action">
            <a href="/posts/<%= post.id %>">글보기</a>
            <%= link_to '글보기', post %>
          </div>
        </div>
      </div>
    </div>
<% end %>
```



이제 show 액션의 컨트롤러를 만들어 보겠습니다.

가장 먼저

```ruby
<%= link_to '글보기', post %>
```

를 누르게 되면 /posts/:id 의 경로를 타고 show 액션으로 이동하게 됩니다. 즉 show 액션에서는 params[:id] 를 통해서 유저가 누른 글의 id 값을 받아올 수 있습니다. 그러므로 Post 모델에서 params[:id] 의 값을 id 로 갖는 글이 무었인지 찾아서 보여주는 로직이 필요합니다.

> app/controllers/posts_controller.rb

```ruby
@post = Post.find(params[:id])
```

find(숫자값) 를 사용하게 되면 해당 모델에서 숫자값에 해당하는 id 를 갖는 객체를 꺼내옵니다.

> app/controllers/posts_controller.rb

```ruby
class PostsController < ApplicationController
  def index
    @posts = Post.all
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new
    @post.title = params[:post][:title]
    @post.writer = params[:post][:writer]
    @post.content = params[:post][:content]
    @post.save
  end

  def show
    @post = Post.find(params[:id])
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
```



보고싶은 post를 꺼내서 @post 에 담았으므로 이제 뷰로 넘어가게 됩니다.

> app/views/posts/show.html.erb
>
> index.html.erb 에서 만든 카드를 가져와서 조금 수정합니다.

```erb
<div class="row">
  <div class="col s12 m12">
    <div class="card white darken-1">
      <div class="card-content dark-text">
        <span class="card-title"><%= @post.title %></span><br>
        <div class="card-panel grey">
          <span class="white-text"><%= @post.content %></span>
        </div>
        <p class="right">글쓴이 : <%= @post.writer %></p>
      </div>
      <div class="card-action">
        <!-- <a href="/posts/<%= @post.id %>">글보기</a> -->
        <%= link_to '수정하기', edit_post_path %>
        <%= link_to '삭제하기', @post, method: :delete %>
        <!-- <%= link_to '삭제하기', post_path, method: :delete %> -->
      </div>
    </div>
  </div>
</div>
```

@post 를 경로로 하는것과 post_path를 경로로 하는 것은 같은 의미를 지닙니다. 삭제를 하기 위해서는 routing 표 에서 보았듯이 DELETE http method 로 요청을 보내주어야 합니다.



## posts#edit

new 와 똑같습니다. 다른점은 new 는 아예 새로 만들었지만 edit 는 id 값을 받아서 그 것에 해당하는 값을 form 에 뿌려주고 고치는 식 입니다.

> app/controllers/posts_controller.rb

```ruby
class PostsController < ApplicationController
  def index
    @posts = Post.all
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new
    @post.title = params[:post][:title]
    @post.writer = params[:post][:writer]
    @post.content = params[:post][:content]
    @post.save
  end

  def show
    @post = Post.find(params[:id])
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
  end

  def destroy
  end
end
```

> app/views/posts/edit.html.erb

```erb
<%= form_for(@post, url: post_path) do |f| %>
    <div class="input-field col s12">
      <%= f.label :title %><br>
      <%= f.text_field :title, :required => true, placeholder: '제목' %>
    </div>
    <div class="input-field col s12">
      <%= f.label :writer %><br>
      <%= f.text_field :writer, :required => true, placeholder: '글쓴이' %>
    </div>
    <div class="input-field col s12">
      <%= f.label :content %><br>
      <%= f.text_area :content, class: 'materialize-textarea' %>
    </div>
    <%= f.submit '글쓰기', class: 'btn waves-effect waves-light right' %>
<% end %>
```

create 에 쓰인 경로는 posts_path 인데, update 에는 post_path 임을 주의 한다.

| Helper                                   | HTTP Verb | Path                      | Controller#Action |
| ---------------------------------------- | --------- | ------------------------- | ----------------- |
| [Path](https://my-note-astrocket.c9users.io/posts#) / [Url](https://my-note-astrocket.c9users.io/posts#) |           |                           |                   |
| posts_path                               | GET       | /posts(.:format)          | posts#index       |
|                                          | POST      | /posts(.:format)          | posts#create      |
| new_post_path                            | GET       | /posts/new(.:format)      | posts#new         |
| edit_post_path                           | GET       | /posts/:id/edit(.:format) | posts#edit        |
| post_path                                | GET       | /posts/:id(.:format)      | posts#show        |
|                                          | PATCH     | /posts/:id(.:format)      | posts#update      |
|                                          | PUT       | /posts/:id(.:format)      | posts#update      |
|                                          | DELETE    | /posts/:id(.:format)      | posts#destroy     |

## posts#update

create 처럼 저장을 해주는데 기존에 있던 @post에 다시 저장해주는 것만 다르다.

> app/controllers/posts_controller.rb

```ruby
class PostsController < ApplicationController
  def index
    @posts = Post.all
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new
    @post.title = params[:post][:title]
    @post.writer = params[:post][:writer]
    @post.content = params[:post][:content]
    @post.save
    render :show
  end

  def show
    @post = Post.find(params[:id])
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    @post.title = params[:post][:title]
    @post.writer = params[:post][:writer]
    @post.content = params[:post][:content]
    @post.save
    render :show
  end

  def destroy
  end
end
```

한가지 포인트는, 업데이트하고나서도 어짜피 보여주는것은 동일하므로 render :show 를 통해서 로직처리 없이 바로 show.html.erb 를 뿌려주도록 한다. 그러면 update 에서 저장이 된 @post 가 곧바로 show.html.erb 로 가게 되므로 상세 글이 보이게 된다.

create 액션 이후에도 render :show 를 통해서 작성된 글을 보여주도록 해주자.

## posts/destroy

삭제 액션은 정말 간단하다. 버튼을 눌렀을때 삭제하고 index 로 가게 하면 끝.

> app/controllers/posts_controller.rb

```ruby
class PostsController < ApplicationController
  def index
    @posts = Post.all
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new
    @post.title = params[:post][:title]
    @post.writer = params[:post][:writer]
    @post.content = params[:post][:content]
    @post.save
    render :show
  end

  def show
    @post = Post.find(params[:id])
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    @post.title = params[:post][:title]
    @post.writer = params[:post][:writer]
    @post.content = params[:post][:content]
    @post.save
    render :show
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to posts_path
  end
end
```

뷰파일은 필요가 없으므로 바로 posts_path 즉 index 액션으로 보내준다. 이때는 @posts 를 꺼내는 로직을 거쳐야 하므로 render 가 아닌, redirect_to 를 써야한다.