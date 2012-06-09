require 'spec_helper'

shared_examples 'Index' do

  it "should be aware of fields to index" do
    user.class.indices.should include(:age)
  end
end
