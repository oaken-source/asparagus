#!/bin/bash

set -e
set -u

## this file is intended to push latest versions of asparagus into the 
## projects it has been integrated in.
## subject to change and probably only really useful on my own machine.

files="asparagus.exp lib/*.tcl steps/*.tcl"

code=/home/andi/code

# dbtesma
cp --parents -urv $files $code/dbtesma/tests/

echo "all up to date"
