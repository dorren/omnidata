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

    before_destroy :log_destroy
    def log_destroy
      "logging destory"
    end

    before_create :announce
    def self.announce
      "new user will be created"
    end
  end

end
