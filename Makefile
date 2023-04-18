HVM := hvm
GHC := ghc
CARGO := cargo
HYPERFINE := hyperfine
MAX_THREADS := $(shell nproc)
THREAD_COUNTS := $(shell seq 1 $(MAX_THREADS))
PARAMS := 20

help:
	# to start a benchmark, use the command 'make benchmark_NAME' where NAME is a folder in 'benchmarks'

clean: clean_radix_sort clean_bubble_sort

clean_%:
	rm -rf $* $*_hvm $*_ghc benchmarks/$*/main.hi benchmarks/$*/main.o

%/target/release/%: benchmarks/%/main.hvm
	cp benchmarks/$*/main.hvm $*.hvm
	$(HVM) compile $*.hvm
	cd $* && $(CARGO) build --offline --release
	rm $*.hvm

%_hvm: %/target/release/%
	cp $*/target/release/$* $*_hvm

%_ghc:
	$(GHC) benchmarks/$*/main.hs -O2 -o $*_ghc

benchmark_%: %_hvm %_ghc
	# using makefile string substitution since hyperfine doesn't support "zipped parameters"
	# see https://github.com/sharkdp/hyperfine/issues/637
	$(HYPERFINE) $(patsubst %,'./$*_hvm run -t % "(Main $(PARAMS))"',$(THREAD_COUNTS)) './$*_ghc $(PARAMS)' --export-markdown output/$*_results.md --export-csv output/$*_results.csv

