require "./spec_helper"

module Tokyocabinet
  describe HDB do
    describe ".open" do
      context "(tmp/xxx.tch)" do
        it "fails when the file is not found" do
          expect_raises(Errno, /Error opening file /) do
            HDB.open("tmp/xxx.tch")
          end
        end
      end

      context "(tmp/xxx.tch, w+)" do
        it "returns a HDB when the file is not found" do
          HDB.open("tmp/xxx.tch", "w+").should be_a(HDB)
        end
      end
    end

    describe "(README)" do
      it "works" do
        hdb = HDB.open("tmp/test.tch", "w+")
        hdb.set("foo", "abc")
        hdb.get("foo").should eq("abc")
        hdb.get?("foo").should eq("abc")
        hdb.get?("xxx").should eq(nil)
        expect_raises(Exception, /not found/i) do
          hdb.get("xxx")
        end
        hdb.del("foo").should eq(true)
        hdb.del("foo").should eq(false)
        hdb.get?("foo").should eq(nil)
        hdb.close
      end
    end
  end
end
