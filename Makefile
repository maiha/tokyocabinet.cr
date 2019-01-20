SHELL=/bin/bash
API_IMPLS := src/tokyocabinet/hdb/api.cr

VERSION=
CURRENT_VERSION=$(shell git tag -l | sort -V | tail -1)
GUESSED_VERSION=$(shell git tag -l | sort -V | tail -1 | awk 'BEGIN { FS="." } { $$3++; } { printf "%d.%d.%d", $$1, $$2, $$3 }')

.PHONY : all test clean spec umount docs
all: docs test umount

test: clean spec check_version_mismatch

clean:
	docker-compose down -v

umount:
	docker run --rm -t -v $$(pwd)/tmp:/v alpine chown -R $$(id -u):$$(id -g) /v

spec:
	./crystal spec -v --fail-fast

docs: doc/api/HDB.md doc/api/API.md

doc/api/HDB.md: src/tokyocabinet/hdb/api.cr Makefile
	@echo "# Tokyocabinet::HDB" > $@
	@echo '```crystal' >> $@
	@egrep '^\s+def ' src/tokyocabinet/hdb/api.cr | grep -v initialize >> $@
	@echo '```' >> $@

doc/api/API.md: doc/api/doc.cr doc/api/list doc/api/impl doc/api/note Makefile
	crystal doc/api/doc.cr > $@

doc/api/list: src/lib_tokyocabinet.cr Makefile
	cat $^ | awk '/^[ ]+fun /{sub("\(", " ");print substr($$2,1,3) "\t" $$2}' | sort | uniq > $@

doc/api/impl: $(API_IMPLS) Makefile
	grep -hv "^\s*#" $(API_IMPLS) | awk '/^[ ]+(proxy|throws)/{print $$2}' | sort | uniq > $@

.PHONY : check_version_mismatch
check_version_mismatch: shard.yml README.md
	diff -w -c <(grep version: README.md) <(grep ^version: shard.yml)

.PHONY : version
version:
	@if [ "$(VERSION)" = "" ]; then \
	  echo "ERROR: specify VERSION as bellow. (current: $(CURRENT_VERSION))";\
	  echo "  make version VERSION=$(GUESSED_VERSION)";\
	else \
	  sed -i -e 's/^version: .*/version: $(VERSION)/' shard.yml ;\
	  sed -i -e 's/^    version: [0-9]\+\.[0-9]\+\.[0-9]\+/    version: $(VERSION)/' README.md ;\
	  echo git commit -a -m "'$(COMMIT_MESSAGE)'" ;\
	  git commit -a -m 'version: $(VERSION)' ;\
	  git tag "v$(VERSION)" ;\
	fi

.PHONY : bump
bump:
	make version VERSION=$(GUESSED_VERSION) -s
