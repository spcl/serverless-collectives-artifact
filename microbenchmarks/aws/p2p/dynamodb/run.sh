#!/bin/bash

SEBS_DIR=$1

${SEBS_DIR}/sebs.py experiment invoke communication-p2p --config benchmark.json --deployment aws --language cpp --language-version all --verbose --output-dir . --output-file invoke.log
${SEBS_DIR}/sebs.py experiment process communication-p2p --config benchmark.json --deployment aws --verbose --output-dir . --output-file process.log

