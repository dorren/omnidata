require 'spec_helper'
require 'shared_orm'
require 'shared_persistence'
require 'shared_association'

describe Omnidata::Adapters::MongodbAdapter do
  let(:mgr) { Omnidata::Adapters::AdapterManager.instance }
  let(:user) { Example::User.new }
  let(:config) {{:adapter => 'mongodb', :database => 'mydb'}}

  before(:all) do
    mgr.reset
    Omnidata.setup_database(:db1, config)
    Omnidata.setup_database(:db2, {:adapter => 'mongodb', :database => 'mydb2'})

    Example::User.use_database(:db1)
    Example::Comment.use_database(:db2)
  end

  before(:each) do
    db = user.class.adapter.database
    table_name = user.class.table_name
    db.collection(table_name).remove

    Omnidata.adapter(:db2).database.collection(user.class.table_name).remove
  end

  it "should find adapter class" do
    user.class.adapter.should be_an_instance_of Omnidata::Adapters::MongodbAdapter
  end

  it "should be able to switch database" do
    user.class.adapter.name.should be(:db1)

    user.class.with_database(:db2) do
      user.class.adapter.name.should be(:db2)
      user.class.create(:name => 'Jack')
      user.class.count.should == 1
    end
    user.class.adapter.name.should be(:db1)
    user.class.count.should == 0
  end

  #include_examples 'Orm'
  #include_examples 'Persistence'
  #include_examples 'Association'
end


