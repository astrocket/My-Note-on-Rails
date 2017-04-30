class Post < ActiveRecord::Base
    validates :title, :writer, :content, presence: true
end
