module Expectacular
  class Assertion
    module BeClose
      def be_close(expected, delta)
        assert (object - expected).abs <= delta, 
               "Expected #{object.inspect} to be close to #{expected} (within +/- #{delta})"
      end
    end

    add BeClose
  end
end
