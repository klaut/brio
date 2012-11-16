module Brio
  module Resources

    class User < Resource
      attr_accessor :id, :created_at, :username, :name, :description, :counts, :follows_you,  :you_follow
    end

  end
end