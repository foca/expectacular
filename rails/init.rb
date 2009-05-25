if Rails.env.test?
  require File.dirname(__FILE__) + "/../lib/expectacular"

  class Test::Unit::TestCase
    include Expectacular::TestCaseMethods
  end
end
