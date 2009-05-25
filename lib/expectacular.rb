module Expectacular
  class Expectation
    instance_methods.each do |method|
      undef_method method unless method.to_s =~ /^__/
    end

    def initialize(object, test_case)
      @object = object
      @test_case = test_case
    end

    def to
      Matcher.new(@object, @test_case, true)
    end

    def not_to
      Matcher.new(@object, @test_case, false)
    end

    private

    def method_missing(message, *args, &block)
      to.send(message, *args, &block)
    end
  end

  class Matcher
    instance_methods.each do |method|
      undef_method method unless method.to_s =~ /^__/
    end

    def initialize(object, test_case, positive_assertion=true)
      @object = object
      @test_case = test_case
      @positive_assertion = positive_assertion
    end

    def be
      self
    end

    private

    def assert!(result, failure_message)
      test_succeeded = (@positive_assertion && result) || 
        (!@positive_assertion && !result)

      @test_case.send :add_failure, failure_message unless test_succeeded
      @test_case.send :add_assertion
    end

    def method_missing(message, *args, &block)
      if message.to_s =~ /^be_(.*)$/
        failure_message  = "Expected #{@object.inspect} to be #{$1}"
        failure_message += " with #{args.join(", ")}" unless args.empty?
        assert! @object.send("#{$1}?", *args, &block), failure_message
      else
        failure_message  = "Expected #{@object.inspect} to #{message}"
        failure_message += " with #{args.join(", ")}" unless args.empty?
        assert! @object.send(message, *args, &block), failure_message
      end
    end
  end

  class ::Test::Unit::TestCase
    def expect(object)
      Expectacular::Expectation.new(object, self)
    end
  end
end
