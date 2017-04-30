# 나만의 메모 만들기

5기 여러분 안녕하세요, 그동안 배웠던 CRUD 를 총 복습하면서 나만의 이쁜 메모장을 만들어 보도록해요.

언제 어디서나 손쉽게 접근 가능하고, 쓸 수 있는 메모장 입니다.

가장먼저 C9.io 에 접속해서 프로젝트를 생성합니다.

## 글 작성에 필요한 컨트롤러와 모델 만들기

1. 컨트롤러

   ```ruby
   rails g controller posts index new create show edit update destroy
   ```

2. 모델

   ```ruby
   rails g model post title:string content:text writer:string
   ```
   