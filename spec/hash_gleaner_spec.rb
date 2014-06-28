# -*- coding: utf-8 -*-
require "spec_helper"

describe HashGleaner do
  describe ".included" do
    let(:clazz) {
      clazz = Class.new(Hash)
      clazz.__send__ :include, HashGleaner
      clazz
    }

    let(:instance) {
      clazz.new
    }

    it "responds to glean method" do
      expect(instance).to respond_to(:glean)
    end
  end
end
