class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      log_in user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      redirect_back_or root_path
    else
      flash[:danger] = 'emailまたはパスワードが間違っています。'
      redirect_to new_session_path
    end
  end

  def destroy
    if logged_in?
      log_out
      flash[:success] = 'ログアウトしました。'
    end
    redirect_to root_path
  end

end
