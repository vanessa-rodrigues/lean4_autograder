#!/usr/bin/env bash

curl https://raw.githubusercontent.com/leanprover/elan/master/elan-init.sh -sSf | sh -s -- -y

~/.elan/bin/elan default leanprover/lean4:stable

~/.elan/bin/lake --version
