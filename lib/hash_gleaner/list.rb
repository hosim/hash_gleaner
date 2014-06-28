# coding: utf-8
require 'hash_gleaner/value_gleaner'
require 'hash_gleaner/missing_keys'

module HashGleaner
  class List
    def initialize(hash, missing_keys)
      @origin = hash
      @hash = {}
      @mode = :optional
      @missing_keys = missing_keys
      @gleaner = ValueGleaner.new(missing_keys)
    end

    def o(name, *options, &block)
      unless @origin.has_key?(name)
        @missing_keys.add(name) if @mode == :required
        return @hash
      end

      @hash[name] = @gleaner.glean(@origin[name], block, {})
      @hash
    end

    def required
      @mode = :required
      @hash
    end

    def optional
      @mode = :optional
      @hash
    end
  end
end
