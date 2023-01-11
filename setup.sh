#!/usr/bin/env bash

curl https://raw.githubusercontent.com/leanprover/elan/master/elan-init.sh -sSf | sh -s -- -y --default-toolchain leanprover/lean4:nightly-2023-01-10

# ~/.elan/bin/elan default leanprover/lean4:nightly

~/.elan/bin/lean --version

cd /autograder/source

~/.elan/bin/lake update

~/.elan/bin/lake exe cache get

~/.elan/bin/lake clean

~/.elan/bin/lake build autograder AutograderTests
