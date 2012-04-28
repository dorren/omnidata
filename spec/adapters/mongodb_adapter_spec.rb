require 'spec_helper'
require 'shared_orm'
require 'shared_persistence'

describe Omnidata::Adapters::MongodbAdapter do
  let(:user) { Example::User.new }
  let(:config) {{:adapter => 'mongodb', :database => 'mydb'}}

  before(:all) do
    user.class.use_database(config)
  end

  before(:each) do
    db = user.class.adapter.database
    table_name = user.class.table_name
    db.collection(table_name).remove
  end

  it "should config" do
    user.class.config.should == config
  end

  it "should find adapter class" do
    user.class.adapter.class.should == Omnidata::Adapters::MongodbAdapter
  end

  include_examples 'Orm'
  include_examples 'Persistence'
end


