require 'spec_helper'

module Brio

  describe Client do

    before :all do
      create_test_rc_file
    end

    after :all do
      delete_test_rc_file
    end

    before :each do
      @client = Client.new
    end

    describe "initialization" do
      it "should load config from rc file" do
        @client.config.empty?.should be_false
        @client.config['token'] == fixture_as_yaml("brio.rc")['config']['token']
      end
    end

    describe 'dynamic methods' do
      it 'should respond to user methods' do
        @client.should respond_to(:get_user)
        @client.should respond_to(:get_user_followers)
        @client.should respond_to(:get_user_following)
        @client.should respond_to(:get_user_muted)
        @client.should respond_to(:create_user_follow)
        @client.should respond_to(:delete_user_follow)
        @client.should respond_to(:create_user_mute)
        @client.should respond_to(:delete_user_mute)
        @client.should respond_to(:get_user_followers_ids)
        @client.should respond_to(:get_user_following_ids)
        @client.should respond_to(:get_user_mentions)
        @client.should respond_to(:get_user_stars)
        @client.should respond_to(:get_user_posts)
        @client.should_not respond_to(:get_something_else)
      end
    end

    describe 'integration' do      
      describe "get user info - whois" do
        it 'should return my own info' do
          endpoint = stub_get('/stream/0/users/me/')
          endpoint.to_return(:body => fixture_as_json("user.json"), :headers => {:content_type => "application/json; charset=utf-8"})
          response = @client.get_user
          a_get('/stream/0/users/me/').should have_been_made
        end

        it 'should return user info defined by id' do
          endpoint = stub_get('/stream/0/users/@joe/')
          endpoint.to_return(:body => fixture_as_json("user.json"), :headers => {:content_type => "application/json; charset=utf-8"})
          response = @client.get_user 'joe'
          a_get('/stream/0/users/@joe/').should have_been_made
        end
      end

      describe "get user followers" do
        it "should return my own followers" do
          endpoint = stub_get('/stream/0/users/me/followers')
          endpoint.to_return(:body => fixture_as_json("users.json"), :headers => {:content_type => "application/json; charset=utf-8"})
          response = @client.get_user_followers
          a_get('/stream/0/users/me/followers').should have_been_made
        end

        it "should return user followers" do
          endpoint = stub_get('/stream/0/users/@joe/followers')
          endpoint.to_return(:body => fixture_as_json("users.json"), :headers => {:content_type => "application/json; charset=utf-8"})
          response = @client.get_user_followers 'joe'
          a_get('/stream/0/users/@joe/followers').should have_been_made
        end

        it "should return user followers by ids" do
          endpoint = stub_get('/stream/0/users/@joe/followers/ids')
          endpoint.to_return(:body => fixture_as_json("users.json"), :headers => {:content_type => "application/json; charset=utf-8"})
          response = @client.get_user_followers_ids 'joe'
          a_get('/stream/0/users/@joe/followers/ids').should have_been_made
        end
      end 

      describe "get user following" do
        it "should return my own following" do
          endpoint = stub_get('/stream/0/users/me/following')
          endpoint.to_return(:body => fixture_as_json("users.json"), :headers => {:content_type => "application/json; charset=utf-8"})
          response = @client.get_user_following
          a_get('/stream/0/users/me/following').should have_been_made
        end

        it "should return user following" do
          endpoint = stub_get('/stream/0/users/@joe/following')
          endpoint.to_return(:body => fixture_as_json("users.json"), :headers => {:content_type => "application/json; charset=utf-8"})
          response = @client.get_user_following 'joe'
          a_get('/stream/0/users/@joe/following').should have_been_made
        end
      end 

      describe "follow/unfollow a user" do
        it 'should follow a user' do
          endpoint = stub_post('/stream/0/users/@joe/follow')
          endpoint.to_return(:body => fixture_as_json("users.json"), :headers => {:content_type => "application/json; charset=utf-8"})
          response = @client.create_user_follow 'joe'
          a_post('/stream/0/users/@joe/follow').should have_been_made
        end

        it 'should unfollow a user' do
          endpoint = stub_delete('/stream/0/users/@joe/follow')
          endpoint.to_return(:body => fixture_as_json("users.json"), :headers => {:content_type => "application/json; charset=utf-8"})
          response = @client.delete_user_follow 'joe'
          a_delete('/stream/0/users/@joe/follow').should have_been_made
        end
      end
    end

  end

end