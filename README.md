# HVM_benchmarks
A benchmark harness for comparing HVM to haskell

Benchmarks are made out of two parts: `main.hvm` which contains the HVM code, and `main.hs` which contains the equivalent haskell code.

To run a specific benchmark, execute the following command: `make benchmark_NAME` where `NAME` is the name of the directory in `benchmarks`.

The harness depends on [HVM](https://github.com/HigherOrderCO/HVM) and [Rust](https://www.rust-lang.org/) to compile the HVM source code,
[GHC](https://www.haskell.org/ghc/) for compiling the haskell code, and [Hyperfine](https://github.com/sharkdp/hyperfine) to evaluate their performance.

The make file uses the following variables:

- `HVM`,`GHC`,`CARGO`,`HYPERFINE`: The path to the binaries of the aformentioned tools. by default the harness assumes they are in the PATH.
- `THREAD_COUNTS`: A list of thread counts. HVM will be measured using each of the counts separately. by default uses counts from 1 to `MAX_THREADS`
- `MAX_THREADS`: The maximum number of threads which HVM will use, unless `THREAD_COUNTS` is set explicitly.
- `PARAMS`: The parameters which the specific benchmark accepts, in both the HVM and haskell version. used to affect the problem size.
