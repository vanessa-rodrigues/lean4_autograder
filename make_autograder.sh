#!/usr/bin/env bash

# lake update

pip install -r requirements.txt

python3 setup_files.py

# zip -r autograder.zip AutograderTests/ lake-packages/ lake-manifest.json lakefile.lean lean-toolchain Main.lean run_autograder setup.sh

zip -r autograder.zip AutograderTests/ lakefile.lean lean-toolchain Main.lean run_autograder setup.sh

rm -rf AutograderTests/*