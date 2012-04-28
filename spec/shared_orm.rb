require 'spec_helper'

shared_examples 'Orm' do

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

