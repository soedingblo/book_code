#---
# Excerpted from "Cucumber Recipes",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/dhwcr for more book information.
#---
# This is how we might have done it with individual scenario hooks:
=begin
require 'selenium-webdriver'

Before do
  @browser = Selenium::WebDriver.for :firefox
end

After do
  @browser.quit
end
=end
