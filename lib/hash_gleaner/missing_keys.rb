# coding: utf-8

module HashGleaner
  class MissingKeys
    def initialize
      @keys = []
    end

    def add(key)
      keys << key
    end

    def has_keys?
      ! keys.empty?
    end

    def clear
      @keys = []
    end

    attr_reader :keys
  end
end
