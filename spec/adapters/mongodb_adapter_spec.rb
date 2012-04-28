require 'spec_helper'
require 'shared_orm'
require 'shared_persistence'

describe Omnidata::Adapters::MongodbAdapter do
  let(:mgr) { Omnidata::Adapters::AdapterManager.instance }
  let(:user) { Example::User.new }
  let(:config) {{:adapter => 'mongodb', :database => 'mydb'}}

  before(:all) do
    mgr.reset
    Omnidata.setup_database(:db1, config)
    Omnidata.setup_database(:db2, {:adapter => 'mongodb', :database => 'mydb2'})

    user.class.use_database(:db1)
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

  include_examples 'Orm'
  include_examples 'Persistence'
end


