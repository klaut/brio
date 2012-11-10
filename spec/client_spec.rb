require 'spec_helper'

describe Brio::Client do

  before :all do
    create_test_rc_file
  end

  after :all do
    delete_test_rc_file
  end

  describe "initialization" do
    before :all do
      @client = Brio::Client.new
    end

    it "should load config from rc file" do
      @client.config.empty?.should be_false
      @client.config['token'] == fixture_as_yaml("brio.rc")['config']['token']
    end
  end

  describe "api requests" do
    before :each do
      @client = Brio::Client.new
    end

    it "should get user's stream if param global not set" do
      stub_get('/stream/0/posts/stream/').with(:query => {"count" => 20}).
        to_return(:body => fixture_as_json("user_stream.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      response = @client.get_stream
      response['data'][0]['text'].should == "This is user stream"
    end

    it "should get global stream if param global set" do
      stub_get('/stream/0/posts/stream/global').with(:query => {"count" => 20}).
        to_return(:body => fixture_as_json("global_stream.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      response = @client.get_stream(true)
      response['data'][0]['text'].should == "This is global stream"
    end

    it "should request for custom count for stream" do
      stub_get('/stream/0/posts/stream/').with(:query => {"count" => 15}).
        to_return(:body => fixture_as_json("user_stream.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      
      @client.get_stream false, 15
      a_get('/stream/0/posts/stream/').with(:query => {"count" => 15}).should have_been_made
    end

    describe "posting to app.net" do
      before :each do
        @text = "@berg FIRST post on this new site #newsocialnetwork"
        @endpoint = stub_post('/stream/0/posts/')
      end

      it "should tell OK if posting successful" do
        @endpoint.to_return(:body => fixture_as_json("post.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        response = @client.post @text
        response.keys.include?('data').should be_true
      end

      it "should fail gracefully if something went wrong" do
        @endpoint.to_return(:body => fixture_as_json("error.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        response = @client.post @text
        response.keys.include?('data').should_not be_true
        response.keys.include?('meta').should be_true
        response['meta'].keys.include?('error_message').should be_true
        response['meta'].keys.include?('code').should be_true
      end
    end

  end

end