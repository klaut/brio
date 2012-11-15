require 'spec_helper'

module Brio
  describe "Hash keys to object attributes" do
    it "should allow to access string keys as properties" do
      a = {"one"=>1}
      a.one.should == 1
    end

    it "should allow to access symbol keys as properties" do
      a = {one: 1}
      a.one.should == 1
    end

    it "should allow to access nested keys as nested properties" do
      a = {"one"=>1, "two"=>2, "three"=>{"one"=>1}}
      a.three.one.should == 1
    end
  end
end 