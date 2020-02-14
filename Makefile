
export PATH := $(shell pwd)/depot_tools/:$(PATH)

all: out/v8/v8/out/x64.release/d8

out/v8/v8/:
	mkdir -p out/v8/
	cd out/v8/ && fetch --no-history v8

out/v8/v8/out/x64.release/: out/v8/v8/
	cd out/v8/v8/ && gn gen --args="v8_postmortem_support=true symbol_level=2 use_debug_fission=false v8_expose_symbols=true v8_enable_pointer_compression=false is_component_build=false" out/x64.release

out/v8/v8/out/x64.release/d8: out/v8/v8/out/x64.release/
	cd out/v8/v8/ && ninja -C out/x64.release d8
