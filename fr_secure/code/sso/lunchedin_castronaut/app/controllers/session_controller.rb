#---
# Excerpted from "Security on Rails",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/fr_secure for more book information.
#---
class SessionController < ApplicationController
  skip_before_filter :check_authentication
  
  def index
    render :action => 'login'
  end
    
  def logout
    reset_session
    CASClient::Frameworks::Rails::Filter.logout(self)
  end
end
