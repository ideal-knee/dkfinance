require 'spec_helper'

describe Transaction do
  before :each do
    Category.delete_all
    Transaction.delete_all
    @user = User.new
  end

  describe "Transaction.create_from_csv_line" do
    it "parses csv line and creates a transaction from it" do
      line = %{"2013-01-02","TRADER JOE'S #503  QPS FRAMINGHAM    MA","-12.96","Groceries"}
      t = Transaction.create_from_csv_line(line, @user)
      t.date.should == Date.parse('2013-01-02')
      t.description.should == "TRADER JOE'S #503  QPS FRAMINGHAM    MA"
      t.amount.should == -12.96
      t.category.name.should == 'Groceries'
    end

    it "creates new categories as necessary" do
      Category.count.should == 0
      t = Transaction.create_from_csv_line(%{"2013-01-02","TRADER JOE'S #503  QPS FRAMINGHAM    MA","-12.96","Groceries"}, @user)
      Category.count.should == 1
    end

    it "uses existing categories if appropriate" do
      c = Category.create(name: "Groceries", user: @user)
      t = Transaction.create_from_csv_line(%{"2013-01-02","TRADER JOE'S #503  QPS FRAMINGHAM    MA","-12.96","Groceries"}, @user)
      t.category.should == c
    end

    it "doesn't blow up on bad input" do
      t = Transaction.create_from_csv_line(%{"2013-01-02 TRADER JOE'S #503  QPS FRAMINGHAM    MA","-12.96","Groceries"}, @user)
      t.should be_nil
    end

    it "handles commas in descriptions correctly" do
      t = Transaction.create_from_csv_line('"2012-09-06","CLICK-TO-PAY PAYMENT, THANK YOU","1837.97","Transfer"', @user)
      t.should_not be_nil
    end
  end
end
