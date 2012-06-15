require 'spec_helper'

shared_examples 'ModelHooks' do
  let(:user_class) { Example::User }
  let(:user) { Example::User.new(:name => 'buddy') }

  it "should define hooks" do
    user_class.should respond_to :before_create
    user_class.should respond_to :before_update
    user_class.should respond_to :before_destroy

    user_class.should respond_to :after_create
    user_class.should respond_to :after_update
    user_class.should respond_to :after_destroy
  end

  it "should call instance hooks" do
    user2 = Example::User.create(:name => "short lived")
    user2.should_receive(:log_destroy)
    user2.destroy
  end

  it "should call class hooks" do
    Example::User.should_receive(:announce)
    user2 = Example::User.create(:name => "short lived")
  end
end
