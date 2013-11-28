require 'spec_helper'

describe Transaction do
  describe "Transaction.create_from_csv_line" do
    it "returns what you pass it" do
      Transaction.create_from_csv_line("asdf").should == "asdf"
    end
  end
end
