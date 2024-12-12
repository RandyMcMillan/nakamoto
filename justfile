#!/usr/bin/env just --justfile

set windows-shell := ["powershell.exe", "-NoLogo", "-Command"]

default:
    @just --list
#install-all:install-node install-wallet
install-all:install-node install-wallet
#cargo install --path node
install-node:
    @cargo install --path node
#cargo install --path wallet
install-wallet:
    @cargo install --path wallet

# vim: set list:
# vim: set noexpandtab:
# vim: set setfiletype make
