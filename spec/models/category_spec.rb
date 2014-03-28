require 'spec_helper'

describe Category do
  describe "Category#machine_name" do
    it "returns the category name lowercase with underscores" do
      c = Category.new(:name => "My Test Name")
      c.machine_name.should == "my_test_name"
    end
  end

  describe "Category.find_by_machine_name" do
    it "returns the category corresponding to the input machine name" do
      u = User.new
      c = Category.create(name: "My Test Name", user: u)
      Category.find_by_machine_name("my_test_name").should == c
    end
  end
end
