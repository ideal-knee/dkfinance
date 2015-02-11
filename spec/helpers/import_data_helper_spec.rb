require 'spec_helper'

describe ImportDataHelper do
  describe "ImportDataHelper.parse_statement" do
    it "parses older Citi statements" do
      data = File.open("spec/resources/citi-2014-10-08.txt").read
      result = ImportDataHelper.parse_statement("citi", data, nil, nil)
      result.should == [
        {
          :date=> Date.new(2014, 10, 6),
          :description=>"AUTOPAY 999990000022744RAUTOPAY AUTO-PMT",
          :amount=>10940.04,
          :category=>nil,
          :user=>nil
        },
        {
          :date=> Date.new(2014, 10, 8),
          :description=>"RETURN CHECK FEE - 100614",
          :amount=>-35.0,
          :category=>nil,
          :user=>nil
        }
      ]
    end
  end
end
