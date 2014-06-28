# coding: utf-8
require 'hash_gleaner/list'
require 'hash_gleaner/missing_keys'

module HashGleaner
  class << self
    def included(base)
      base.__send__ :include, InstanceMethods
    end

    def apply(hash, proc=nil, &block)
      missing_keys = MissingKeys.new
      action = (block if block_given?) || (proc if proc.is_a? Proc)
      h = List.new(hash, missing_keys).instance_eval(&action) if action
      raise MissingKeyException.new(missing_keys) if missing_keys.has_keys?
      h
    end
  end

  module InstanceMethods
    def glean(proc=nil, &block)
      HashGleaner.apply(self, proc, &block)
    end
  end

  class MissingKeyException < StandardError
    def initialize(missing_keys)
      msg = "Missing required keys #{missing_keys.keys.uniq}"
      super(msg)
    end
  end
end
