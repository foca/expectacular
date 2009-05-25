require "test/unit"
require "contest"
require File.dirname(__FILE__) + "/../lib/expectacular"

begin
  require "redgreen"
rescue LoadError
end

class StubTestCase
  def initialize
    @assertions = 0
    @failures = []
  end

  attr_reader :assertions

  def add_assertion
    @assertions += 1
  end

  def add_failure(message)
    @failures << message
  end

  def failures
    @failures.size
  end

  def failure_messages
    @failures
  end
end

class ExpectacularTestCase < Test::Unit::TestCase
  include Expectacular::TestCaseMethods

  attr_reader :stub_test_case

  setup do
    @stub_test_case = StubTestCase.new
  end

  def mock_expectation_for(object)
    yield Expectacular::Expectation.new(object, stub_test_case)
  end
end
