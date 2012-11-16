require 'spec_helper'

module Brio
  module Resources

    describe User do

      before :all do
        @error_json = fixture_as_json('error.json')
      end

      describe "single User" do
        before :all do
          @user_json = fixture_as_json('user.json')
        end

        it "should create one User object from jason data" do
          user = User.create_from_json @user_json
          user.username.should == 'tanja'
          user.description.text.should == "lurking in an infinite pool. currently in scotland. interested in tech, startups and the bigger picture.\r\n\u2665: ruby, python, coffeescript, haskell, music, illustration\r\nt: @tanjapislar \r\nb: heroesneverpanic.com\r\ni: https://gumroad.com/tanjapislar"
        end

        it "should create a NullResource if error" do
          user = User.create_from_json @error_json
          user.should be_kind_of NullResource
        end
      end

      describe "collection of User objects" do
        before :all do
          @user_json = fixture_as_json('users.json')
        end

        it "should return a collections of User objects" do
          users = User.create_from_json @user_json
          users.size.should == 2
          users.each do |u|
            u.should be_kind_of User
          end
        end
      end
      
    end

  end
end