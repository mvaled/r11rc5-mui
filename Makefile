SHELL := /bin/bash
sources := $(shell find src/ -type f -name "*.res")

current_dir := $(abspath $(lastword $(MAKEFILE_LIST)))
current_dir := $(shell dirname $(current_dir))
PATH := $(current_dir)/node_modules/.bin/:$(PATH)


node_modules yarn.lock: package.json
	yarn install
	touch node_modules

format: $(sources) yarn.lock node_modules
	rescript format -all

.PHONY: format

compile: $(sources) yarn.lock node_modules
	@if [ -n "$(INSIDE_EMACS)" ]; then \
	    NINJA_ANSI_FORCED=0 rescript build -with-deps; \
	else \
		rescript build -with-deps; \
	fi

clean:
	rescript clean
.PHONY: clean

dce: $(sources) yarn.lock node_modules
	yarn run reanalyze -dce -suppress src/libs -ci

.PHONY: dce
