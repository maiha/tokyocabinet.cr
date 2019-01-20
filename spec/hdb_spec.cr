require "./spec_helper"

private macro clean
  Pretty::Dir.clean("tmp")
end

module Tokyocabinet
  describe HDB do
    describe "(README)" do
      it "works" do
        hdb = HDB.open("tmp/test.tch")

        hdb.set("foo", "abc")
        hdb.count.should eq(1)

        hdb.get("foo").should eq("abc")
        hdb.get?("foo").should eq("abc")
        hdb.get?("xxx").should eq(nil)
        expect_raises(RecordNotFound, /xxx/i) do
          hdb.get("xxx")
        end
        hdb.del("foo").should eq(true)
        hdb.del("foo").should eq(false)
        hdb.get?("foo").should eq(nil)

        hdb.close
      end
    end

    describe "#each" do
      it "enumerates records with keys" do
        clean
        HDB["tmp/test.tch"].set({"a" => "1", "b" => "2"})

        # works twice
        2.times do
          hash = Hash(String, String).new
          hdb = HDB["tmp/test.tch"]
          hdb.each{ |key| hash[key] = hdb.get(key)}
          hash.should eq({"a" => "1", "b" => "2"})
        end
      end
    end

    describe "#connect(&block)" do
      it "ensures connection" do
        clean
        hdb = HDB.new("tmp/test.tch")
        hdb.opened?.should eq(false)
        hdb.connect do
          hdb.opened?.should eq(true)
        end
        hdb.close
      end
    end

    describe ".create" do
      it "writes database" do
        clean
        HDB.create("tmp/test.tch")
        HDB["tmp/test.tch", "r"].count.should eq(0)
      end

      it "respects bnum" do
        clean
        HDB.create("tmp/test.tch", bnum: 16)
        HDB["tmp/test.tch"].bnum.should eq(17) # ceiled to prime number
      end

      it "ignores when the file already exists" do
        clean
        HDB.create("tmp/test.tch", bnum: 17)
        HDB["tmp/test.tch"].bnum.should eq(17)

        HDB.create("tmp/test.tch", bnum: 100)
        HDB["tmp/test.tch"].bnum.should eq(17)
      end

      it "deletes existing file when :force is set" do
        clean
        HDB.create("tmp/test.tch", bnum: 17)
        HDB["tmp/test.tch"].bnum.should eq(17)

        HDB.create("tmp/test.tch", bnum: 59, force: true)
        HDB["tmp/test.tch"].bnum.should eq(59)
      end
    end

    describe ".open" do
      context "(default)" do
        it "act as mode=w+" do
          clean
          hdb = HDB.open("tmp/xxx.tch")
          hdb.set("foo", "1")
          hdb.close
        end
      end

      context "(mode: r)" do
        it "fails when the file is not found" do
          clean
          expect_raises(FileNotFound, /test.tch/) do
            HDB.open("tmp/test.tch", "r").close
          end
        end

        it "(stub data)" do
          HDB.new("tmp/test.tch").set("foo", "1")
        end

        it "can read" do
          HDB.new("tmp/test.tch", "r").get("foo").should eq("1")
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
          clean
          expect_raises(FileNotFound, /test.tch/) do
            HDB.open("tmp/test.tch", "w").close
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
          clean
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

      context "(mode: t)" do
        it "truncates existing file" do
          clean
          HDB.new("tmp/test.tch", "w+").set("foo", "1")

          HDB.new("tmp/test.tch", "w+").count.should eq(1)
          HDB.new("tmp/test.tch", "wt+").count.should eq(0)
        end
      end

      context "(deadlock)" do
        it "fails when the same file has been opened by same pthread" do
          a = HDB.open("tmp/test.tch")
          expect_raises(ThreadingError, /The file is already opened and is locked/) do
            HDB.open("tmp/test.tch").close
          end
          a.close

          # works after unlocked
          b = HDB.open("tmp/test.tch")
          b.close
        end
      end

      describe "(unlock)" do
        it "works without lock" do
          clean

          a = HDB.open("tmp/test.tch", "w+").unlock
          a.opened?.should be_false
          a.set("foo", "1")
          
          b = HDB.open("tmp/test.tch", "w+").unlock
          b.opened?.should be_false
          b.set("bar", "2")

          a.close
          b.close
        end
      end
    end
  end
end
