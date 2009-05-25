$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__))

module Expectacular
  class Expectation
    def initialize(object, test_case)
      @object = object
      @test_case = test_case
    end

    def to
      Assertion.new(@object, @test_case, true)
    end

    def not_to
      Assertion.new(@object, @test_case, false)
    end
  end

  class Assertion
    instance_methods.each do |method|
      undef_method method unless method.to_s =~ /^__/
    end

    def self.add(*modules, &block)
      modules << Module.new(&block) if block
      include *modules
    end

    attr_reader :object

    def initialize(object, test_case, positive_assertion=true)
      @object = object
      @test_case = test_case
      @positive_assertion = positive_assertion
    end

    def be
      self
    end

    private

    def assert(result, failure_message)
      test_succeeded = (@positive_assertion && result) ||
        (!@positive_assertion && !result)

      @test_case.send :add_failure, failure_message unless test_succeeded
      @test_case.send :add_assertion
    end

    def method_missing(message, *args, &block)
      super
    rescue NoMethodError
      failure_message  = "Expected #{object.inspect} to #{message}"
      failure_message += " with #{args.join(", ")}" unless args.empty?
      assert object.send(message, *args, &block), failure_message
    end
  end

  module TestCaseMethods
    def expect(object)
      Expectacular::Expectation.new(object, self)
    end
  end
end

require "expectacular/be_predicate"
require "expectacular/be_a"
