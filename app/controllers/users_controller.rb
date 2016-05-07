class UsersController < ApplicationController
before_action :set_user, only: [:edit,:update, :followings, :followers]
before_action :check_user,only: [:edit, :update, :followings, :followers]

  def show # 追加
   @user = User.find(params[:id])
   @microposts = @user.microposts.order(created_at: :desc)
   
    if current_user == @user
      @users_ing = current_user.following_users
      @users_er = current_user.follower_users
    else
      @users_ing = @user.following_users
      @users_er = @user.follower_users
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user # ここを修正
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    if @user.update(user_params)
      # 保存に成功した場合はトップページへリダイレクト
      flash[:success] = "プロフィールを登録しました"
      redirect_to @user
    else
      # 保存に失敗した場合は編集画面へ戻す
      render 'edit'
    end
  end
  
  def followings
    @users = current_user.following_users
  end
  
  def followers
    @users = current_user.follower_users
  end
  
  private
  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation,:profile,:area)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def check_user
    unless current_user == @user
      redirect_to root_path
    end
  end

end
