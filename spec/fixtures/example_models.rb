module Example
  class Comment
    include Omnidata::Model

    attribute :user_id, String
    attribute :body, String
  end

  class User
    include Omnidata::Model

    attribute :name, String
    attribute :age, Integer
    attribute :comments, [Comment]

    index :age
  end

end
