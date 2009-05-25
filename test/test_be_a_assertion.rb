require File.dirname(__FILE__) + "/test_helper"

class TestBeAAssertion < ExpectacularTestCase
  test "reports ancestorship correctly" do
    mock_expectation_for("a string") {|e| e.to.be_a(String) }
    mock_expectation_for("a string") {|e| e.not_to.be_a(Numeric) }

    expect(stub_test_case.assertions).to == 2
    expect(stub_test_case.failures).to == 0
  end

  test "failure messages are nice to read" do
    mock_expectation_for("foo") {|e| e.to.be_a(Numeric) }

    expect(stub_test_case.failure_messages.first).to == 'Expected "foo" to be a Numeric'
  end
end
