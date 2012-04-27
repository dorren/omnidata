module Example
  class User
    include Omnidata::Model

    attribute :name, String
    attribute :age, Integer
  end
end
