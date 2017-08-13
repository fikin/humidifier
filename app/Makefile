SHELL=/bin/bash

LUA_PATH="target/lua/?.lua;;"

.PHONY : all
all : compile

prepare-contrib : | target/lua

prepare-sources : prepare-contrib
	cp src/main/lua/*.lua target/lua/
prepare-resources : prepare-contrib
	echo "main resources are empty"
	#@if [ "$$(ls -A src/main/resources)" ] ; then cp -R src/main/resources/* target/lua/ ; fi ;
compile : prepare-sources prepare-resources

prepare-test-contrib : | target/lua target/lua/node.lua
target/lua :
	mkdir -p target/lua
target/lua/node.lua : target/lua 
	$(MAKE) -C submodules/nodemcu-lua-mocks dist
	cp submodules/nodemcu-lua-mocks/target/dist/* target/lua/
prepare-test-sources : prepare-contrib prepare-test-contrib
	cp src/test/lua/*.lua target/lua/
prepare-test-resources : prepare-contrib
	@if [ "$$(ls -A src/test/resources)" ] ; then cp -R src/test/resources/* target/lua/ ; fi ;
test_files = $(wildcard target/lua/?est*.lua)
.PHONY: $(test_files)
test: compile prepare-test-resources prepare-test-sources $(test_files)
$(test_files) :
	LUA_PATH=$(LUA_PATH) lua $@

dist :
	rm -rf target/dist
	mkdir -p target/dist
	cp src/main/lua/*.lua target/dist/
	cp src/main/resources/*.lua target/dist/

clean :
	rm -rf target

