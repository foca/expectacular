require "test/unit"
require "contest"
require File.dirname(__FILE__) + "/../lib/expectacular"

begin
  require "redgreen"
rescue LoadError
end

class TestExpectacular < Test::Unit::TestCase
  test "it might even work" do
    expect(3).not_to.be > 5
    expect(5).not_to.be_zero
    expect(nil).to.be_nil
    expect(1).to == 1
  end
end
