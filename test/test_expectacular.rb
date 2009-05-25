require File.dirname(__FILE__) + "/test_helper"

class TestExpectacular < ExpectacularTestCase
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
      mock_expectation_for(0) {|e| e.to.is_a?(Numeric) }

      expect(stub_test_case.assertions).to == 1
      expect(stub_test_case.failures).to == 0
    end

    test "can use the #be sugar for clarity" do
      mock_expectation_for(0) {|e| e.to.be >= 0 }

      expect(stub_test_case.assertions).to == 1
      expect(stub_test_case.failures).to == 0
    end

    context "generating failure messages" do
      test 'uses the "expected #{object} to #{message} with #{args} when using the normal form' do
        mock_expectation_for(2) {|e| e.to.be > 4 }

        expect(stub_test_case.failure_messages.first).to == "Expected 2 to > with 4"
      end
    end
  end

  context "adding new assertions" do
    module CustomAssertion
      class << self
        attr_accessor :called
      end

      def be_able_to_foo
        CustomAssertion.called = true
      end
    end

    test "can add a module" do
      Expectacular::Assertion.add CustomAssertion
      mock_expectation_for(Object.new) {|e| e.to.be_able_to_foo }

      expect(CustomAssertion.called).to == true
    end

    test "can add a block for simple extensions" do
      Expectacular::Assertion.add do
        def be_able_to_bar
          CustomAssertion.called = true
        end
      end
      mock_expectation_for(Object.new) {|e| e.to.be_able_to_bar }

      expect(CustomAssertion.called).to == true
    end
  end
end
