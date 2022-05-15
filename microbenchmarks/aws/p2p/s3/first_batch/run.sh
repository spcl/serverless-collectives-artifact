#!/bin/bash

SEBS_DIR=$1

${SEBS_DIR}/sebs.py experiment invoke communication-p2p --config benchmark.json --deployment aws --language cpp --language-version all --verbose --output-dir .
${SEBS_DIR}/sebs.py experiment process communication-p2p --config benchmark.json --deployment aws --language cpp --language-version all --verbose --output-dir .
