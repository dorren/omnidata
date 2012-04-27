require 'spec_helper'

describe Omnidata::Model do
  let(:user) { Example::User.new }

  it "should be new record" do
    user.should be_new_record
  end

  it "should save" do
    user.name = 'someone'
    user.save
    user.should_not be_new_record
  end

  it "should destroy" do
    user.should respond_to(:destroy)
  end

  it "should count" do
    Example::User.should respond_to(:count)
  end

  it "should have default table name" do
    Example::User.table_name.should == 'example_users'
  end

end
