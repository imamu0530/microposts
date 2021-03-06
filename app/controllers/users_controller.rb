class UsersController < ApplicationController
before_action :set_user, only: [:edit,:update]
before_action :check_user,only: [:edit, :update]

  def show # 追加
   @user = User.find(params[:id])
   @microposts = @user.microposts.order(created_at: :desc)
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
