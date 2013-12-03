module SessionsHelper
  def sign_in(user)
    cookies[:remember_token] = user.id
    self.current_user = user
  end

  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
  end

  def signed_in?
    !current_user.nil?
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    user_id = cookies[:remember_token]
    @current_user ||= User.find_by_id(user_id)
  end

  def current_user?(user)
    user == current_user
  end

  def store_location
    session[:return_to] = request.url if request.get?
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end
  
  def signed_in_user
    unless signed_in?
      store_location
      notice = 'Please sign in.' if request.url != root_url
      redirect_to signin_url, notice: notice
    end
  end

end
