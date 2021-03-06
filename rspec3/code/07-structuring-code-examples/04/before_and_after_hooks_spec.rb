#---
# Excerpted from "Effective Testing with RSpec 3",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/rspec3 for more book information.
#---
module MyApp
  class Configuration
  end
end

RSpec.describe MyApp::Configuration do
  before(:example) do
    @original_env = ENV.to_hash
  end

  after(:example) do
    ENV.replace(@original_env)
  end

  it 'can mutate env' do
    ENV['FOO'] = '1'
  end

  it 'isolates mutations from other examples' do
    expect(ENV['FOO']).to eq nil
  end

end

class WebBrowser
  def self.launch; end

  def self.shutdown; end
end

RSpec.describe 'Web interface to my thermostat' do
  before(:context) do
    WebBrowser.launch
  end

  after(:context) do
    WebBrowser.shutdown
  end

  it 'passes' do
  end

end
