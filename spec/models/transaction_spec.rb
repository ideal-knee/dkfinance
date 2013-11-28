require 'spec_helper'

describe Transaction do
  before :each do
    Category.delete_all
    Transaction.delete_all
  end

  describe "Transaction.create_from_csv_line" do
    it "parses csv line and creates a transaction from it" do
      line = %{"2013-01-02","TRADER JOE'S #503  QPS FRAMINGHAM    MA","-12.96","Groceries"}
      t = Transaction.create_from_csv_line(line)
      t.date.should == Date.parse('2013-01-02')
      t.description.should == "TRADER JOE'S #503  QPS FRAMINGHAM    MA"
      t.amount.should == -12.96
      t.category.name.should == 'Groceries'
    end
  end
end
