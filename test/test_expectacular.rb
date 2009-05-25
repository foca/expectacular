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

class TestExpectacular < Test::Unit::TestCase
  attr_reader :stub_test_case

  setup do
    @stub_test_case = StubTestCase.new
  end

  def mock_expectation_for(object)
    yield Expectacular::Expectation.new(object, stub_test_case)
  end

  context "reporting back to the test case" do
    test "a met expectation adds an assertion, but not a failure" do
      mock_expectation_for(1) {|e| e.to == 1 }

      expect(stub_test_case.assertions).to == 1
      expect(stub_test_case.failures).to.be_zero
    end

    test "an unmet expectation adds both an assertion and a failure" do
      mock_expectation_for(1) {|e| e.to == 2 }

      expect(stub_test_case.assertions).to == 1
      expect(stub_test_case.failures).to == 1
    end

    test "multiple expectations add multiple assertions" do
      mock_expectation_for(1) {|e| e.to == 1 }
      mock_expectation_for(2) {|e| e.to == 2 }
      mock_expectation_for(3) {|e| e.to == 3 }

      expect(stub_test_case.assertions).to == 3
    end

    test "multiple unmet expectations add multiple failures" do
      mock_expectation_for(1) {|e| e.to == 2 }
      mock_expectation_for(2) {|e| e.to == 2 }
      mock_expectation_for(3) {|e| e.to == 2 }

      expect(stub_test_case.failures).to == 2
    end
  end

  context "positive expectations" do
    test "can be done straight on the expected object" do
      mock_expectation_for(1) {|e| e == 1 }

      expect(stub_test_case.assertions).to == 1
      expect(stub_test_case.failures).to == 0
    end

    test "can be done on the #to proxy" do
      mock_expectation_for(1) {|e| e.to == 1 }

      expect(stub_test_case.assertions).to == 1
      expect(stub_test_case.failures).to == 0
    end
  end

  context "negative expectations" do
    test "can only be done on the #not_to proxy" do
      mock_expectation_for(1) {|e| e.not_to == 2 }

      expect(stub_test_case.assertions).to == 1
      expect(stub_test_case.failures).to == 0
    end
  end

  context "when asserting" do
    test "can assert for any message the object understands" do
      mock_expectation_for(0) {|e| e.is_a?(Numeric) }

      expect(stub_test_case.assertions).to == 1
      expect(stub_test_case.failures).to == 0
    end

    test "can use the #be_foo form to check for foo? == true" do
      mock_expectation_for(0) {|e| e.to.be_zero }

      expect(stub_test_case.assertions).to == 1
      expect(stub_test_case.failures).to == 0
    end

    test "can use the #be sugar for clarity" do
      mock_expectation_for(0) {|e| e.to.be.zero? }

      expect(stub_test_case.assertions).to == 1
      expect(stub_test_case.failures).to == 0
    end

    context "generating failure messages" do
      test 'uses the "expected #{object} to be #{expected}" when using the be_foo form' do
        mock_expectation_for(1) {|e| e.to.be_zero }

        expect(stub_test_case.failure_messages.first).to == "Expected 1 to be zero"
      end

      test 'uses the "expected #{object} to #{message} with #{args} when using the normal form' do
        mock_expectation_for(2) {|e| e.to.be > 4 }

        expect(stub_test_case.failure_messages.first).to == "Expected 2 to > with 4"
      end
    end
  end
end
