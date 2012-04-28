module Example
  class User
    include Omnidata::Model

    attribute :name, String
    attribute :age, Integer
  end

  class Comment
    include Omnidata::Model

    attribute :user_id, String
    attribute :body, String
  end
end
