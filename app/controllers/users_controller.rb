class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = 'アカウント登録しました。'
      redirect_to @user
    else
      flash[:danger] = 'アカウント登録に失敗しました。'
      redirect_to action: :new
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:success] = "ユーザー情報を更新しました。"
      redirect_to @user
    else
      flash[:danger] = "ユーザー情報を更新できませんでした。"
      redirect_to @user
    end
  end

  def destroy
    @user.destroy
    flash[:success] = 'アカウントを削除しました。'
    redirect_to controller: "tops", action: "index"
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password)
  end

  def logged_in_user
    if !(logged_in?)
      store_location
      flash[:danger] = 'ログインしてください。'
      redirect_to new_session_path
    end
  end

  def correct_user
    @user = User.find_by(id: params[:id])
    if @user.nil? || (@user != current_user)
      flash[:danger] = '編集したいアカウントでログインしてください。'
      redirect_to root_path
    end
  end
end
