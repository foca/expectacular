require File.dirname(__FILE__) + "/test_helper"

class TestBeAAssertion < ExpectacularTestCase
  test "reports ancestorship correctly" do
    mock_expectation_for(0) {|e| e.to.be_close(0, 0) }
    mock_expectation_for(1) {|e| e.to.be_close(1, 0.1) }
    mock_expectation_for(2) {|e| e.not_to.be_close(1, 0.99) }

    expect(stub_test_case.assertions).to == 3
    expect(stub_test_case.failures).to == 0
  end

  test "failure messages are nice to read" do
    mock_expectation_for(2) {|e| e.to.be_close(1, 0.5) }

    expect(stub_test_case.failure_messages.first).to == "Expected 2 to be close to 1 (within +/- 0.5)"
  end
end
