require "./spec_helper"

module Tokyocabinet
  describe HDB do

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

        hdb.set("foo", "abc")
        hdb.count.should eq(1)
        
        hdb.close
      end
    end

    describe ".open" do
      context "(default)" do
        it "fails when the file is not found" do
          expect_raises(Errno, /Error opening file/) do
            HDB.open("tmp/xxx.tch")
          end
        end
      end

      context "(mode: r)" do
        it "fails when the file is not found" do
          Pretty::Dir.clean("tmp")
          expect_raises(Errno, /Error opening file/) do
            HDB.open("tmp/test.tch", "r")
          end
        end

        it "(stub data)" do
          hdb = HDB.open("tmp/test.tch", "w+")
          hdb.set("foo", "1")
          hdb.close
        end

        it "can read" do
          hdb = HDB.open("tmp/test.tch", "r")
          hdb.get("foo").should eq("1")
          hdb.close
        end

        it "can't write" do
          hdb = HDB.open("tmp/test.tch", "r")
          expect_raises(IO::Error, /File not open for writing/) do
            hdb.set("foo", "2")
          end
          hdb.close
        end
      end

      context "(mode: w)" do
        it "fails when the file is not found" do
          Pretty::Dir.clean("tmp")
          expect_raises(Errno, /Error opening file/) do
            HDB.open("tmp/test.tch", "w")
          end
        end

        it "(stub data)" do
          hdb = HDB.open("tmp/test.tch", "w+")
          hdb.set("foo", "1")
          hdb.close
        end

        it "can read" do
          hdb = HDB.open("tmp/test.tch", "w")
          hdb.get("foo").should eq("1")
          hdb.close
        end

        it "can write" do
          hdb = HDB.open("tmp/test.tch", "w")
          hdb.set("foo", "2")
          hdb.get("foo").should eq("2")
          hdb.close
        end
      end

      context "(mode: w+)" do
        it "creates an empty db when the file is not found" do
          Pretty::Dir.clean("tmp")
          hdb = HDB.open("tmp/test.tch", "w+")
          hdb.set("foo", "1")
          hdb.close
        end

        it "can read" do
          hdb = HDB.open("tmp/test.tch", "w+")
          hdb.get("foo").should eq("1")
          hdb.close
        end

        it "can write" do
          hdb = HDB.open("tmp/test.tch", "w")
          hdb.set("foo", "2")
          hdb.get("foo").should eq("2")
          hdb.close
        end
      end
    end
  end
end
