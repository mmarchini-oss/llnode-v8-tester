
export PATH := $(shell pwd)/depot_tools/:$(PATH)

.PHONY: d8
all: d8

out/v8/v8/:
	mkdir -p out/v8/
	cd out/v8/ && fetch --no-history v8

out/v8/v8/out/x64.release/: out/v8/v8/
	cd out/v8/v8/ && gn gen --args="v8_postmortem_support=true symbol_level=1 use_debug_fission=false v8_expose_symbols=true v8_enable_pointer_compression=false is_component_build=false is_debug=false" out/x64.release

d8: out/v8/v8/out/x64.release/
	cd out/v8/v8/ && ninja -C out/x64.release d8
	cp out/v8/v8/out/x64.release/d8 .
	cp out/v8/v8/out/x64.release/snapshot_blob.bin .

current-symbols: d8
	nm ./d8 | grep v8dbg_ | awk '{print $$3}' | sort > current-symbols

.PHONY: run
run: d8 current-symbols run.sh
	./run.sh

.PHONY: artifacts
artifacts: d8 current-symbols
	mkdir -p ./artifacts/
	cp currenty-symbols ./artifacts/
	cp ./d8 ./artifacts/
