require 'spec_helper'

describe Omnidata::Adapters::Mysql::Index do
  let(:mgr) { Omnidata::Adapters::AdapterManager.instance }
  let(:user) { Example::User.new }
  let(:config)  {{:adapter => 'mysql', :database => 'omnidata_test', :username => 'root'}}
  let(:config2) {{:adapter => 'mysql', :database => 'omnidata_test2', :username => 'root'}}
  let(:age_cfg) { ['users_age_index', 
                   [[:user_id, String], [:age, Integer]]
                  ]
                }

  let(:index) { Example::UserAgeIndex.new }

  before(:all) do
    mgr.reset
    Omnidata.setup_database(:db1, config)
    Omnidata.setup_database(:db2, config2)
    
    Example::User.use_database(:db1)
    Example::Comment.use_database(:db2)

    @index_class = Omnidata::Adapters::Mysql::Index.build_index_class(*age_cfg)
    @index_class.use_database(:db1)
  end

  before(:each) do
    db = user.class.adapter.database
    Example::User.delete_all

    Example::User.with_database(:db2) do
      Example::User.delete_all
    end
  end

  it "should find index class" do
    @index_class.new.should be_kind_of(Omnidata::Adapters::Mysql::Index)
  end

  it "should have configured class name" do
    @index_class.name.should       == 'users_age_index'
    @index_class.table_name.should == 'users_age_index'
  end

  it "should generate to_sql" do
    sql = @index_class.to_sql
    sql.should == %{\
CREATE TABLE users_age_index (
  user_id varchar(255) NOT NULL,
  age int(4) NOT NULL,
  KEY (user_id),
  KEY (age)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;}
  end

  it "should have index config" do
    idx_name = Example::User.index_name(:age)
    Example::User.indices[idx_name].should_not be_nil
  end

  it "should create index" do
    idx_name = Example::User.index_name(:age)
    idx_class = Example::User.create_index(idx_name)
    idx_class.new.should be_kind_of(Omnidata::Adapters::Mysql::Index)
  end
end

