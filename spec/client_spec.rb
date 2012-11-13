require 'spec_helper'

module Brio

  describe Client do

    before :all do
      create_test_rc_file
    end

    after :all do
      delete_test_rc_file
    end

    describe "initialization" do
      before :all do
        @client = Client.new
      end

      it "should load config from rc file" do
        @client.config.empty?.should be_false
        @client.config['token'] == fixture_as_yaml("brio.rc")['config']['token']
      end
    end

    describe "api requests" do
      before :each do
        @client = Client.new
      end

      it "should get user's stream if param global not set" do
        stub_get('/stream/0/posts/stream/').with(:query => {"count" => 20, "include_deleted" => 0}).
          to_return(:body => fixture_as_json("user_stream.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        response = @client.get_stream
        response.last.text.should == "This is user stream"
      end

      it "should get global stream if param global set" do
        stub_get('/stream/0/posts/stream/global').with(:query => {"count" => 20, "include_deleted" => 0}).
          to_return(:body => fixture_as_json("global_stream.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        response = @client.get_stream(true)
        a_get('/stream/0/posts/stream/global').with(:query => {"count" => 20, "include_deleted" => 0}).should have_been_made
        response.last.text.should == "This is global stream"
      end

      it "should request for custom count for stream" do
        stub_get('/stream/0/posts/stream/').with(:query => {"count" => 15, "include_deleted" => 0}).
          to_return(:body => fixture_as_json("user_stream.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        
        @client.get_stream false, 15
        a_get('/stream/0/posts/stream/').with(:query => {"count" => 15, "include_deleted" => 0}).should have_been_made
      end

      describe "posting to app.net" do
        before :each do
          @text = "@berg FIRST post on this new site #newsocialnetwork"
          @endpoint = stub_post('/stream/0/posts/')
        end

        # it 'should have a cool post method' do
        #   @client.dpost :create, text: "tralala"
        #   @client.dpost :delete, id: '1'
        #   @client.dpost :reply, to: '1', text: 'yo'
        #   # @client.post :repost, id: '1'
        #   # @client.post :star, id: '1'
        #   # @client.post :replies, id: '1'
        # end

        it "should be OK if posting successful" do
          @endpoint.to_return(:body => fixture_as_json("post.json"), :headers => {:content_type => "application/json; charset=utf-8"})
          response = @client.post text: @text
          a_post('/stream/0/posts/').with(body: {text: "#{@text}"}, :headers => {'Content-Type' => 'application/json'}).should have_been_made
          response.should be_kind_of Resources::Post
        end

        it "should create NullPost if error returned from ADN" do
          @endpoint.to_return(:body => fixture_as_json("error.json"), :headers => {:content_type => "application/json; charset=utf-8"})
          response = @client.post text: @text
          response.should be_kind_of Resources::NullPost
        end

        it 'should be able to delete a post' do
          endpoint = stub_delete('/stream/0/posts/1')
          endpoint.to_return(:body => fixture_as_json("post.json"), :headers => {:content_type => "application/json; charset=utf-8"})
          response = @client.delete_post '1'
          endpoint.should have_been_requested
        end

        it 'should be able to reply to a post' do
          @endpoint.to_return(:body => fixture_as_json("post.json"), :headers => {:content_type => "application/json; charset=utf-8"})
          response = @client.post reply_to: '1', text: @text
          a_post('/stream/0/posts/').with(body: {text: "#{@text}", reply_to: "1"}, :headers => {'Content-Type' => 'application/json'}).should have_been_made
        end

        it 'should be able to repost a post' do
          endpoint = stub_post('/stream/0/posts/1/repost')
          endpoint.to_return(:body => fixture_as_json("post.json"), :headers => {:content_type => "application/json; charset=utf-8"})
          @client.repost '1'
          a_post('/stream/0/posts/1/repost').should have_been_made
        end
      end

    end

  end

end