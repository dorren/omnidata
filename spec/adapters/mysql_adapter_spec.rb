require 'spec_helper'
require 'shared_orm'
require 'shared_model_hooks'
require 'shared_persistence'
require 'shared_association'

describe Omnidata::Adapters::MysqlAdapter do
  let(:mgr) { Omnidata::Adapters::AdapterManager.instance }
  let(:user) { Example::User.new(:name => 'mysql user') }
  let(:config) {{:adapter => 'mysql', :database => 'omnidata_test', :username => 'root'}}

  before(:all) do
    mgr.reset
    Omnidata.setup_database(:db1, config)
    Omnidata.setup_database(:db2, {:adapter => 'mysql', :database => 'omnidata_test2', :username => 'root'})

    Example::User.use_database(:db1)
    Example::Comment.use_database(:db2)
  end

  before(:each) do
    db = user.class.adapter.database
    Example::User.delete_all

    Example::User.with_database(:db2) do
      Example::User.delete_all
    end
  end

  it "should find adapter class" do
    user.class.adapter.should be_an_instance_of Omnidata::Adapters::MysqlAdapter
  end

  include_examples 'Orm'
  include_examples 'ModelHooks'
  include_examples 'Persistence'
  include_examples 'Association'
end
