module SessionsHelper
  # SessionsHelper is included in application_controller.rb


  # logs in the given user.
  def log_in(user)
    session[:user_id] = user.id
  end
  
  # returns the current logged-in user (if any)
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
    @current_user ||= User.find_by(id: session[:user_id])
  end
  
  # returns true if the user is logged in, false otherwise
  def logged_in?
    # not empty
    !current_user.nil?
  end
  
  # logs out the current user
  def log_out
    session.delete(:user_id)
    # session[:user_id] = nil     # same thing
    @current_user = nil
  end
end
