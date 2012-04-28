require 'spec_helper'

shared_examples "Persistence" do
  before(:each) do
    user.name = 'someone'
  end

  it "should raise error if adapter not found" do
    lambda { user.class.use_database(:bad_db) }.should raise_error(Omnidata::Adapters::AdapterError)
  end

  it "should create" do
    user.should be_new_record
    user.save
    user.should_not be_new_record
  end

  describe "with saved model" do
    before(:each) do
      @user = Example::User.create(:name => 'Jack')
    end
    
    it "should find" do
      user = Example::User.find(@user.id.to_s)
      user.id.should == @user.id
      user.name.should == 'Jack'
    end

    it "should not find" do
      user2 = Example::User.create(:name => 'Jill')
      user2.destroy

      user = Example::User.find(user2.id) # mongo requires valid id, not just random str.
      user.should be_nil
    end

    it "should find all" do
      users = Example::User.find
      users.each do |x|
        x.should be_instance_of user.class
      end
    end

    describe "test pagination" do
      before(:each) do
        user2 = Example::User.create(:name => 'user2')
        user3 = Example::User.create(:name => 'user3')
      end

      it "should use limit" do
        users = Example::User.find(:limit => 1)
        users.size.should == 1
        users.first.name.should == 'Jack'
      end

      it "should skip" do
        users = Example::User.find(:limit => 1, :skip => 1)
        users.first.name.should == 'user2'
      end
    end

    it "should destroy" do
      lambda { @user.destroy }.should change(Example::User, :count).from(1).to(0)
    end
  end

  it "should count" do
    user.class.count.should == 0
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
end
