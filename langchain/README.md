# Rust devcontainer
My `.devcontainer` for rust development. Builds a rust development environment, slims it, and pushes to dockerhub.

## Environment test
Includes a simple Makefile to test that the environment can at least compile a rust binary. Run `make testenv` to print some environment information, as well as compile and run a hello world example in rust. 

## Included tools
- rust
- cargo
- rustfmt
- clippy
- rust-analyzer

## Intended Usage
This is intended to be used as a base image for rust development. The goal is to eventually add some flags for things like adding a database, or adding a web server, etc. Generally assumes that VSCode is the editor of choice, and that the user is using the DevContainer extension.