module SessionsHelper
  def sign_in(user)
    user.remember_me! #calls remember_me! in user.rb which creates a remember token
    cookies[:remember_token]= {:value => user.remember_token,
                              :expires => 20.years.from_now.utc}
                              #built in rails cookie utility - acts like a hash while passing the remember token to the browser as a cookie and setting its expiration
    self.current_user = user #function call to current_user= with (user)
  end
  def current_user=(user) #sets @current user after sign in
    @current_user=user
  end
  def current_user #called from within the application - returns @current user if defined or calls user_from_remember_token
    @current_user ||=user_from_remember_token
  end
  
  def user_from_remember_token
    remember_token=cookies[:remember_token] #again cookies utility acts like a hash, and allows you to check out the cookie in the browser
    User.find_by_remember_token(remember_token) unless remember_token.nil?#and find the associated user (if there is one)
  end
  def signed_in? #used by spec to see if CONTROLLER is signed_in.  calls current user function above to see if @current_user is defined or has a remember token
    !current_user.nil? 
  end
  def sign_out
    cookies.delete(:remember_token)
    self.current_user=nil
  end
end
