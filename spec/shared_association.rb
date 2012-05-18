require 'spec_helper'

shared_examples 'Association' do

  it "should save association" do
    user = Example::User.new(:name => 'buddy')
    user.comments = []
    user.comments <<  {:body => 'blah'} 
  end
end

