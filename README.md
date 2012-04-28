# omnidata

warning:
**Currently in super alpha stage, everything's subjected to change.**

Omnidata allows you to define your models in persistence agnostic fashion, so 
model can be saved in any database you like, mongodb, couchdb, redis, etc. 

Gem uses [Virtus](https://github.com/solnic/virtus#readme) for defining attributes.

For example:

    Omnidata.setup_database(:db1, {:adapter => 'mongodb', :database => 'mydb'})
    Omnidata.setup_database(:db2, {:adapter => 'mongodb', :database => 'mydb2'})

    class User
      include Omnidata::Model
      use_database :db1

      attribute :name, String
      attribute :age, Integer
    end

    user = User.new(:name => 'Jack Hunt', :age => 27)
    user.save
    User.find(user.id)

    # to switch to another db temporarily.
    User.with_database(:db2) do
      User.find(user.id)
    end



