require 'spec_helper'

describe ImportDataHelper do
  describe "ImportDataHelper.parse_statement" do
    it "parses older Citi statements" do
      data = File.open("spec/resources/citi-2014-10-08.txt").read
      result = ImportDataHelper.parse_statement("old-citi", data, nil, nil)
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

    it "parses newer Citi statements" do
      data = File.open("spec/resources/citi-2014-11-10.csv").read
      result = ImportDataHelper.parse_statement("citi", data, nil, nil)
      result.should == [
        {
          :date=> Date.new(2014, 10, 8),
          :description=>"GILT GROUPE            877-2800545   NY",
          :amount=>-79.25,
          :category=>nil,
          :user=>nil
        },
        {
          :date=> Date.new(2014, 11, 6),
          :description=>"AUTOPAY 999990000022744RAUTOPAY AUTO-PMT",
          :amount=>4375.46,
          :category=>nil,
          :user=>nil
        },
      ]
    end

    it "does not blow up on the actual line endings" do
      data = File.open("spec/resources/citi-2014-11-10-binary.csv").read
      expect { ImportDataHelper.parse_statement("citi", data, nil, nil) }.to_not raise_error
    end
  end
end
