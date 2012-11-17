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

    describe 'api calls' do  
      before :each do
        Resources::User.stub(:create_from_json)
        Resources::Post.stub(:create_from_json)
      end

      describe "get user info - whois" do
        it 'should call my own info' do
          endpoint = stub_get('/stream/0/users/me/')
          @client.get_user
          a_get('/stream/0/users/me/').should have_been_made
        end

        it 'should call user info defined by id' do
          endpoint = stub_get('/stream/0/users/@joe/')
          @client.get_user '@joe'
          a_get('/stream/0/users/@joe/').should have_been_made
        end
      end

      describe "get user followers" do
        it "should call my own followers" do
          endpoint = stub_get('/stream/0/users/me/followers')
          @client.get_user_followers
          a_get('/stream/0/users/me/followers').should have_been_made
        end

        it "should call user followers" do
          endpoint = stub_get('/stream/0/users/@joe/followers')
          @client.get_user_followers '@joe'
          a_get('/stream/0/users/@joe/followers').should have_been_made
        end

        it "should call user followers by ids" do
          endpoint = stub_get('/stream/0/users/@joe/followers/ids')
          response = @client.get_user_followers_ids '@joe'
          a_get('/stream/0/users/@joe/followers/ids').should have_been_made
        end
      end 

      describe "get user following" do
        it "should call my own following" do
          endpoint = stub_get('/stream/0/users/me/following')
          @client.get_user_following
          a_get('/stream/0/users/me/following').should have_been_made
        end

        it "should call user following" do
          endpoint = stub_get('/stream/0/users/@joe/following')
          @client.get_user_following '@joe'
          a_get('/stream/0/users/@joe/following').should have_been_made
        end

        it "should call user following by ids" do
          endpoint = stub_get('/stream/0/users/@joe/following/ids')
          response = @client.get_user_following_ids '@joe'
          a_get('/stream/0/users/@joe/following/ids').should have_been_made
        end
      end 

      describe "follow/unfollow a user" do
        it 'should call follow a user' do
          endpoint = stub_post('/stream/0/users/@joe/follow')
          @client.create_user_follow '@joe'
          a_post('/stream/0/users/@joe/follow').should have_been_made
        end

        it 'should call unfollow a user' do
          endpoint = stub_delete('/stream/0/users/@joe/follow')
          @client.delete_user_follow '@joe'
          a_delete('/stream/0/users/@joe/follow').should have_been_made
        end
      end

      describe "mute/unmute a user" do
        it 'should call mute a user' do
          endpoint = stub_post('/stream/0/users/@joe/mute')
          @client.create_user_mute '@joe'
          a_post('/stream/0/users/@joe/mute').should have_been_made
        end

        it 'should call unmute a user' do
          endpoint = stub_delete('/stream/0/users/@joe/mute')
          @client.delete_user_mute '@joe'
          a_delete('/stream/0/users/@joe/mute').should have_been_made
        end
      end

      describe "user api calls when returning Post objects" do
        it "should call my mentions" do
          endpoint = stub_get('/stream/0/users/me/mentions')
          @client.get_user_mentions
          a_get('/stream/0/users/me/mentions').should have_been_made
        end

        it "should call user mentions" do
          endpoint = stub_get('/stream/0/users/@joe/mentions')
          @client.get_user_mentions '@joe'
          a_get('/stream/0/users/@joe/mentions').should have_been_made
        end

        it "should call my starts" do
          endpoint = stub_get('/stream/0/users/me/stars')
          @client.get_user_stars
          a_get('/stream/0/users/me/stars').should have_been_made
        end

        it "should call user starts" do
          endpoint = stub_get('/stream/0/users/@joe/stars')
          @client.get_user_stars '@joe'
          a_get('/stream/0/users/@joe/stars').should have_been_made
        end

        it "should call my posts" do
          endpoint = stub_get('/stream/0/users/me/posts')
          @client.get_user_posts
          a_get('/stream/0/users/me/posts').should have_been_made
        end

        it "should call user posts" do
          endpoint = stub_get('/stream/0/users/@joe/posts')
          @client.get_user_posts '@joe'
          a_get('/stream/0/users/@joe/posts').should have_been_made
        end
      end
    end

  end

end