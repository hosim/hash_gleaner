# coding: utf-8

module HashGleaner
  class ValueGleaner
    def initialize(missing_keys)
      @missing_keys = missing_keys
    end

    def value_type(value)
      return :array if value.is_a? Array
      return :hash  if value.is_a? Enumerable
      return :single
    end

    def glean(value, proc, empty_hash=Empty)
      case value_type(value)
      when :single
        value
      when :hash
        proc ? List.new(value, @missing_keys).instance_eval(&proc) : empty_hash
      when :array
        value.each_with_object([]) {|val, a|
          v = glean(val, proc)
          a << v unless v == Empty
        }
      end
    end
  end

  class Empty; end
end
