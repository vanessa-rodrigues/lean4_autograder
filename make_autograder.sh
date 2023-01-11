#!/usr/bin/env bash

pip install -r requirements.txt

python3 setup_files.py

zip -r autograder.zip AutograderTests/ lakefile.lean lean-toolchain Main.lean run_autograder setup.sh

rm -rf AutograderTests/*