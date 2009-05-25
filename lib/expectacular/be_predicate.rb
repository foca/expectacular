module Expectacular
  class Assertion
    module Predicate
      def method_missing(message, *args, &block)
        if message.to_s =~ /^be_(.*)$/
          failure_message  = "Expected #{object.inspect} to be #{$1}"
          failure_message += " with #{args.join(", ")}" unless args.empty?
          assert object.send("#{$1}?", *args, &block), failure_message
        else
          super
        end
      end
    end

    add Predicate
  end
end
