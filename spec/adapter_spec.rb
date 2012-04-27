require 'spec_helper'

describe Omnidata::Adapters::AbstractAdapter do
  let(:user) { Example::User.new }
  let(:config) {{:adapter => 'mongodb', :database => 'mydb'}}

  before(:all) do
    Example::User.use_database(config)
  end

  it "should config" do
    Example::User.config.should == config
  end

  it "should find adapter class" do
    Example::User.adapter.class.should == Omnidata::Adapters::MongodbAdapter
  end
end

