require 'spec_helper'

shared_examples "Persistence" do
  before(:each) do
    user.name = 'someone'
  end

  it "should create" do
    user.should be_new_record
    user.save
    user.should_not be_new_record
  end

  it "should destroy" do
    user = Example::User.new(:name => 'Jack')
    user.save
    lambda { user.destroy }.should change(Example::User, :count).from(1).to(0)
  end

  it "should count" do
    user.class.count.should == 0
  end
end
