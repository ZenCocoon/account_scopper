$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'spec'
require 'spec/autorun'

require 'boot' unless defined?(ActiveRecord)

require File.dirname(__FILE__) + '/lib/load_schema'
require File.dirname(__FILE__) + '/lib/load_models'
require File.dirname(__FILE__) + '/lib/load_fixtures'

require File.dirname(__FILE__) + "/../init"

Spec::Runner.configure do |config|  
  load_models
  
  config.before do
    load_schema
    load_fixtures
    Account.current_account = accounts(:localhost)
  end

  config.after do
    Account.current_account = nil
  end
end
