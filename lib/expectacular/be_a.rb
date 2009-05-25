module Expectacular
  class Assertion
    module BeA
      def be_a(ancestor)
        assert object.is_a?(ancestor), "Expected #{object.inspect} to be a #{ancestor.name}"
      end
    end

    add BeA
  end
end
