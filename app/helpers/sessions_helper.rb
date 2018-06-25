module SessionsHelper
  # SessionsHelper is included in application_controller.rb


  # logs in the given user.
  def log_in(user)
    session[:user_id] = user.id
  end
  
  # remembers a user in a persistent session
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end
  
  # returns true if the given user is the current user
  def current_user?(user)
    user == current_user
  end
  
  # returns the user corresponding to the remember token cookie
  def current_user
    ## Rails convention is not to hit the database multiple times if you don't have to
    # User.find_by(id: session[:user_id])
    ## so we do momoization (no 'r')
    # if @current_user.nil?
    #   @current_user = User.find_by(id: session[:user_id])
    # else
    #   @current_user
    # end
    ## or the shorter way
    # @current_user ||= User.find_by(id: session[:user_id])
    
    # the if below is an assignment not a double-equals/comparison
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end
  
  # returns true if the user is logged in, false otherwise
  def logged_in?
    # not empty
    !current_user.nil?
  end
  
  # forgets a persistent session
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
  
  # logs out the current user
  def log_out
    forget(current_user)
    session.delete(:user_id)
    # session[:user_id] = nil     # same thing
    @current_user = nil
  end
  
  # redirects to stored location (or to the default)
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end
  
  # stores the URL trying to be accessed
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
  
end