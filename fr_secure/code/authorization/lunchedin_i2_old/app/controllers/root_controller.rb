#---
# Excerpted from "Security on Rails",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/fr_secure for more book information.
#---
class RootController < ApplicationController
  skip_before_filter :check_authentication
  skip_before_filter :authorization_filter
  
  def index
    @comments = Comment.find(:all, :limit => 5, :order => 'created_on desc')
    @tags = Tag.find(:all, :limit => 25)
  end
end
