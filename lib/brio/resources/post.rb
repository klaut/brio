module Brio
  module Resources

    class Post < Resource
      attr_accessor :id, :user, :created_at, :text, :num_replies, :reply_to
    end

  end
end