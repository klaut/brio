require 'spec_helper'
require 'yaml'

describe Brio::RCFile do

  describe "loading and saving token" do
    before :each do
      @rcfile = Brio::RCFile.instance
    end
    after :each do
      delete_test_rc_file
    end

    it "should save user token to file" do
      @rcfile['token'] = "123456789"
      File.exist?(test_rc_file).should be_true
      f = YAML.load_file test_rc_file
      f['config']['token'].should == "123456789"
    end

    it "should retrive user token from file" do
      @rcfile['token'] = "123456789"
      @rcfile['token'].should  == "123456789"
    end
  end


end