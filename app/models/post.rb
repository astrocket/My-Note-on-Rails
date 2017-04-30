class Post < ActiveRecord::Base
    validates :title, :writer, :content, presence: true, :message => "제목, 글쓴이, 내용 중 하나가 비어 있습니다."
end
