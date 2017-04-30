class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  
  def index
    @posts = Post.all
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    #@post = Post.new
    #@post.title = params[:post][:title]
    #@post.writer = params[:post][:writer]
    #@post.content = params[:post][:content]
    @post.save
    render :show
  end

  def show
    #@post = Post.find(params[:id])
  end

  def edit
    #@post = Post.find(params[:id])
  end

  def update
    #@post = Post.find(params[:id])
    #@post.title = params[:post][:title]
    #@post.writer = params[:post][:writer]
    #@post.content = params[:post][:content]
    #@post.save
    @post.update(post_params)
    render :show
  end

  def destroy
    #@post = Post.find(params[:id])
    @post.destroy
    redirect_to posts_path
  end
  
  private
  
  def post_params
    params.require(:post).permit(:title, :writer, :content)
  end
  
  def set_post
    @post = Post.find(params[:id])
  end
end
