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

    describe 'dynamic methods' do
      it 'should respond to post methods' do
        @client.should respond_to(:get_post_stream)
        @client.should respond_to(:get_post_stream_global)
        @client.should respond_to(:get_post_stream_unified)
        
        @client.should respond_to(:delete_post)
        @client.should respond_to(:create_post) #used also for replies

        @client.should respond_to(:create_post_repost)
        @client.should respond_to(:delete_post_repost)

        @client.should respond_to(:create_post_star)
        @client.should respond_to(:delete_post_star)

        @client.should respond_to(:get_post_replies)

        @client.should respond_to(:get_post_stars) #returns users
        @client.should respond_to(:get_post_reposters) #returns users
        # @client.get_post_stream count: 15, include_deleted: 0
        # @client.create_post reply_to: 233456, text: "yoyoyoyoyo"
      end
    end

    describe "api calls" do
      before :each do
        Resources::User.stub(:create_from_json)
        Resources::Post.stub(:create_from_json)
      end

      it "should call my stream" do
        endpoint = stub_get('/stream/0/posts/stream')
        @client.get_post_stream
        a_get('/stream/0/posts/stream').should have_been_made
      end

      it "should call my stream with count and no deleted" do
        endpoint = stub_get('/stream/0/posts/stream').with(:query => {"count" => 10, "include_deleted" => 0})
        @client.get_post_stream count:10, include_deleted: 0
        a_get('/stream/0/posts/stream').with(:query => {"count" => 10, "include_deleted" => 0}).should have_been_made
      end

      it "should call my global stream" do
        endpoint = stub_get('/stream/0/posts/stream/global')
        @client.get_post_stream_global
        a_get('/stream/0/posts/stream/global').should have_been_made
      end

      it "should call my unified stream" do
        endpoint = stub_get('/stream/0/posts/stream/unified')
        @client.get_post_stream_unified
        a_get('/stream/0/posts/stream/unified').should have_been_made
      end

      it "should call create new post" do
        endpoint = stub_post('/stream/0/posts/')
        @client.create_post text: "yo"
        a_post('/stream/0/posts/').with(:body => { text: "yo"}).should have_been_made
      end

      it "should call create a reply to a post" do
        endpoint = stub_post('/stream/0/posts/')
        @client.create_post text: "yo", reply_to: '1'
        a_post('/stream/0/posts/').with(:body => { text: "yo", reply_to: '1'}).should have_been_made
      end

      it "should call delete a post" do
        endpoint = stub_delete('/stream/0/posts/1/')
        @client.delete_post '1'
        a_delete('/stream/0/posts/1/').should have_been_made
      end

      it "should call create a repost to a post" do
        endpoint = stub_post('/stream/0/posts/1/repost')
        @client.create_post_repost '1'
        a_post('/stream/0/posts/1/repost').should have_been_made
      end

      it "should call delete a repost to a post" do
        endpoint = stub_delete('/stream/0/posts/1/repost')
        @client.delete_post_repost '1'
        a_delete('/stream/0/posts/1/repost').should have_been_made
      end

      it "should call create a star to a post" do
        endpoint = stub_post('/stream/0/posts/1/star')
        @client.create_post_star '1'
        a_post('/stream/0/posts/1/star').should have_been_made
      end

      it "should call delete a star to a post" do
        endpoint = stub_delete('/stream/0/posts/1/star')
        @client.delete_post_star '1'
        a_delete('/stream/0/posts/1/star').should have_been_made
      end

      it "should call get replies for a post" do
        endpoint = stub_get('/stream/0/posts/1/replies')
        @client.get_post_replies '1'
        a_get('/stream/0/posts/1/replies').should have_been_made
      end

      it "should call get stars for a post" do
        endpoint = stub_get('/stream/0/posts/1/stars')
        @client.get_post_stars '1'
        a_get('/stream/0/posts/1/stars').should have_been_made
      end

      it "should call get reposters for a post" do
        endpoint = stub_get('/stream/0/posts/1/reposters')
        @client.get_post_reposters '1'
        a_get('/stream/0/posts/1/reposters').should have_been_made
      end

    end

  end
end