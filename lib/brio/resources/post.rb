module Brio
  module Resources

    class Post < Resource

      attr_accessor :id, :user, :created_at, :text

    end

  end
end