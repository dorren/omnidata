# omnidata

*Currently in super alpha stage, everything's subjected to change.*

Omnidata allows you to define your models in persistence agnostic fashion, so 
you can save in any database you like, mongodb, couchdb, redis, etc. 

Gem uses [Virtus](https://github.com/solnic/virtus#readme) for defining attributes.


For example:

    class User
      include Omnidata::Model
      use_database :adapter => 'mongodb', :database => 'mydb'

      attribute :name, String
      attribute :age, Integer
    end

    user = User.new(:name => 'Jack Hunt', :age => 27)
    user.save
    User.find(user.id)

== Copyright

Copyright (c) 2012 Dorren Chen. See LICENSE.txt for
further details.

