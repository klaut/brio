module Brio
  module Resources

    class Post < Resource
      attr_accessor :id, :user, :created_at, :text, :num_replies, :num_stars, :num_reposts, :reply_to, :repost_of
    end

  end
end