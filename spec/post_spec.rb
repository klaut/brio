require 'spec_helper'

module Brio
  module Resources

    describe Post do

      before :all do
        @error_json = fixture_as_json('error.json')
      end
      
      describe 'Creating single Post' do 
        before :all do
          @post_json = fixture_as_json('post.json')
        end

        it 'should create one Post object from json data' do
          post = Post.create_from_json @post_json
          post.id.should == '1'
          post.username.should == 'watura'
          post.text.should == '@berg FIRST post on this new site #newsocialnetwork'
        end 

      end

      describe 'Creating multiple Post objects' do
        before :all do
          @stream_json = fixture_as_json('user_stream.json')
        end

        it 'should create may Post objects from the stream json data' do
          posts = Post.create_many_from_json @stream_json
          posts.size.should == 20
          posts.each do |p|
            p.should be_kind_of Post
          end
        end
      end

    end

  end
end