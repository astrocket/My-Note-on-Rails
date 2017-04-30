# 나만의 메모 만들기

5기 여러분 안녕하세요, 그동안 배웠던 CRUD 를 총 복습하면서 나만의 이쁜 메모장을 만들어 보도록해요.

언제 어디서나 손쉽게 접근 가능하고, 쓸 수 있는 메모장 입니다.

가장먼저 C9.io 에 접속해서 프로젝트를 생성합니다.



## 글 작성에 필요한 컨트롤러와 모델 만들기

1. 컨트롤러 ( 여러개의 post 를 관리하기 위한 컨트롤러이므로 posts 로 s 를 붙여서 써줍니다. )

   ```ruby
   rails g controller posts index new create show edit update destroy
   ```
   ​

2. 모델

   ```ruby
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



## 디자인 작업

이번에는 새로운 CSS/HTML 프레임워크로 디자인을 해보겠습니다.

