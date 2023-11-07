module SessionHelpers
  def is_logged_in?
    !session[:user_id].nil?
  end

  def log_in(user)
    session[:user_id] = user.id
  end

  def remember(user)
    user.remember
    cookies.permanent.encrypted[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def log_in_remember(user)
    log_in user
    remember user
  end
end