#---
# Excerpted from "Using JRuby",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/jruby for more book information.
#---
require 'java'

os   = java.lang.System.get_property 'os.name'
home = java.lang.System.get_property 'java.home'
mem  = java.lang.Runtime.get_runtime.free_memory

puts "Running on #{os}"
puts "Java home is #{home}"
puts "#{mem} bytes available in JVM"

