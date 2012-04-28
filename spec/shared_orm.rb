require 'spec_helper'

shared_examples 'Orm' do

  it "should init" do
    user2 = user.class.new(:name => 'someone', :id => 123)
    user2.name.should == 'someone'
    user2.id.should == 123
  end

  it "should be new record" do
    user.should be_new_record
  end

  it "should have default table name" do
    user.class.table_name.should == 'example_users'
  end

  it "should change table name" do
    user.class.table_name = 'users'
    user.class.table_name.should == 'users'
  end
end

