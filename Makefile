
.PHONY : all
all : compile

init :
	git submodule update --init --recursive

compile : init
	$(MAKE} -C app compile

test : compile
	$(MAKE) -C app test

