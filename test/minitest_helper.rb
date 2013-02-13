$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require "minitest/autorun"
require "minitest/mock"
require "minitest/matchers"
require 'resque_spec/minitest_matchers'
require 'resque_scheduler'
require 'resque_spec/scheduler'
require 'timecop'

Dir[File.expand_path(File.join(File.dirname(__FILE__),'support','**','*.rb'))].each {|f| require f}

class MiniTest::Spec

end
