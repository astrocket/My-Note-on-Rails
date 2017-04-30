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
     post 'posts/create'
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

   아래 처럼 수정하면 단 한 줄 로도 동일한 기능을 구현할 수 있습니다.

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

해당 액션의 뷰로가서 뷰를 만들어 보겠습니다.



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



