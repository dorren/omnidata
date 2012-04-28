require 'spec_helper'

describe Omnidata::Adapters::AdapterManager do
  let(:mgr) { Omnidata::Adapters::AdapterManager.instance }
  let(:config) {{:adapter => 'mongodb', :database => 'mydb'}}

  before(:each){ mgr.reset }

  it "should init" do
    mgr.adapters.should be_empty
  end

  describe "with one adapter setup" do
    let!(:adapter) { mgr.add(:db1, config) }

    it "should store named configurations" do
      adapter.should be_a_kind_of(Omnidata::Adapters::AbstractAdapter)
      mgr.adapter(:db1).should == adapter
    end

    it "should set adapter's name" do
      mgr.adapter(:db1).name.should == :db1
    end

    it "should not add twice" do
      lambda { mgr.add(:db1, config) }.should raise_error(Omnidata::Adapters::AdapterError)
    end
  end

  it "should use shortcut method" do
    mgr.adapters.should be_empty
    Omnidata.setup_database(:db1, config)
    mgr.adapters.should_not be_empty
  end
end
