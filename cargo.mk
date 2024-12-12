##
##===============================================================================
##make cargo-*
cargo-help:### 	cargo-help
	@awk 'BEGIN {FS = ":.*?###"} /^[a-zA-Z_-]+:.*?###/ {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
cargo-release-all:### 	cargo-release-all
## 	cargo-release-all 	recursively cargo build --release
	for t in */Cargo.toml;  do echo $$t; cargo b -r -vv --manifest-path $$t; done
cargo-clean-all:### 	cargo-clean-all - clean release artifacts
## 	cargo-clean-all 	recursively cargo clean --release
	for t in */Cargo.toml;  do echo $$t; cargo clean --release -vv --manifest-path $$t; done
cargo-publish-all:### 	cargo-publish-all
## 	cargo-clean-all 	recursively publish rust projects
	for t in */Cargo.toml;  do echo $$t; cargo publish -vv --manifest-path $$t; done
cargo-sweep:### 	cargo-sweep sweep -t 1 -r
## 	cargo-sweep sweep -t 1 -r
	type -P cargo-sweep && cargo-sweep sweep -t 1 -r

cargo-b:cargo-build### 	cargo b
cargo-build:### 	cargo build
## 	cargo-build q=true
	@. $(HOME)/.cargo/env
	@RUST_BACKTRACE=all && \
	for t in */Cargo.toml;  do echo $$t; cargo build $(QUIET) -vv --manifest-path $$t; done
cargo-i:cargo-install
cargo-install:### 	cargo install --path $$t
	@. $(HOME)/.cargo/env
	@RUST_BACKTRACE=all && \
	for t in */;  do echo $$t; cargo install $(QUIET) -vv --path $$t 2>/dev/null; done
cargo-br:cargo-build-release### 	cargo-br
## 	cargo-br q=true
cargo-build-release:### 	cargo-build-release
## 	cargo-build-release q=true
	@. $(HOME)/.cargo/env
	@RUST_BACKTRACE=all && \
	for t in */Cargo.toml;  do echo $$t; cargo build -r $(QUIET) -vv --manifest-path $$t; done
cargo-c:cargo-check
cargo-check:### 	cargo-check
	@. $(HOME)/.cargo/env
	@RUST_BACKTRACE=all && \
	for t in */;  do echo $$t; cargo check $(QUIET) -vv 2>/dev/null; done
cargo-bench:### 	cargo-bench
	@. $(HOME)/.cargo/env
	@RUST_BACKTRACE=all && \
	for t in */Cargo.toml;  do echo $$t; cargo bench $(QUIET) -vv --manifest-path $$t; done
cargo-t:cargo-test
cargo-test:### 	cargo-test
	@. $(HOME)/.cargo/env
	@RUST_BACKTRACE=all && \
	for t in */Cargo.toml;  do echo $$t; cargo test $(QUIET) -vv --manifest-path $$t; done
cargo-report:### 	cargo-report
	@. $(HOME)/.cargo/env
	@RUST_BACKTRACE=all && \
	for t in */;  do echo $$t; cargo report future-incompatibilites --id 1 $(QUIET) $(FORCE) -vv --path $$t; done

cargo-deps-gnostr-all:cargo-deps-gnostr-cat cargo-deps-gnostr-cli cargo-deps-gnostr-command cargo-deps-gnostr-grep cargo-deps-gnostr-legit cargo-deps-gnostr-sha256### 	cargo-deps-gnostr-all
cargo-deps-gnostr-cat:### 	cargo-deps-gnostr-cat
	rustup-init -y -q --default-toolchain $(TOOLCHAIN) && \
    source "$(HOME)/.cargo/env" && \
    cd deps/gnostr-cat && $(MAKE) cargo-build-release cargo-install
    ## cargo $(Z) deps/gnostr-cat install --path .
cargo-deps-gnostr-cli:### 	cargo-deps-gnostr-cli
	cargo -Z unstable-options  -C deps/gnostr-cli install --path .
cargo-deps-gnostr-command:### 	cargo-deps-gnostr-command
	cargo -Z unstable-options  -C deps/gnostr-command install --path .
cargo-deps-gnostr-grep:### 	cargo-deps-gnostr-grep
	cargo -Z unstable-options  -C deps/gnostr-grep install --path .
cargo-deps-gnostr-legit:### 	cargo-deps-gnostr-legit
	cargo -Z unstable-options  -C deps/gnostr-legit install --path .
cargo-deps-gnostr-sha256:### 	cargo-deps-gnostr-sha256
	cargo -Z unstable-options  -C deps/gnostr-sha256 install --path .
##===============================================================================
cargo-dist:### 	cargo-dist -h
	cargo dist -h
cargo-dist-build:### 	cargo-dist-build
	RUSTFLAGS="--cfg tokio_unstable" cargo dist build
cargo-dist-manifest-global:### 	cargo dist manifest --artifacts=all
	cargo dist manifest --artifacts=all
# vim: set noexpandtab:
# vim: set setfiletype make
#
