require File.dirname(__FILE__) + "/test_helper"

class TestPredicateAssertions < ExpectacularTestCase
  test "can use the #be_foo form to check for foo? == true" do
    mock_expectation_for(0) {|e| e.to.be_zero }

    expect(stub_test_case.assertions).to == 1
    expect(stub_test_case.failures).to == 0
  end

  test 'uses the "expected #{object} to be #{expected}" as a failure message when using the be_foo form' do
    mock_expectation_for(1) {|e| e.to.be_zero }

    expect(stub_test_case.failure_messages.first).to == "Expected 1 to be zero"
  end
end
