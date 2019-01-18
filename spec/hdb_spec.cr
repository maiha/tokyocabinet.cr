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
        expect_raises(RecordNotFound, /xxx/i) do
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
          expect_raises(FileNotFound, /xxx.tch/) do
            HDB.open("tmp/xxx.tch")
          end
        end
      end

      context "(mode: r)" do
        it "fails when the file is not found" do
          Pretty::Dir.clean("tmp")
          expect_raises(FileNotFound, /test.tch/) do
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
          expect_raises(FileNotFound, /test.tch/) do
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

      context "(deadlock)" do
        it "fails when the same file has been opened by same pthread" do
          a = HDB.open("tmp/test.tch")
          expect_raises(ThreadingError, /The file is already opened and is locked/) do
            b = HDB.open("tmp/test.tch")
          end
          a.close

          # works after unlocked
          b = HDB.open("tmp/test.tch")
          b.close
        end
      end

      context "(permission)" do
        it "fails when the same file has wrong permissions" do
          File.chmod("tmp/test.tch", 0o400)
          expect_raises(Tokyocabinet::NoPermission, /test.tch/) do
            HDB.open("tmp/test.tch", "w")
          end
          File.chmod("tmp/test.tch", 0o644)
        end
      end
    end
  end
end
