#!/bin/bash
git clone --recurse-submodules https://github.com/ucl-pond/kde_ebm.git
if [ "$1" == "-e" ]; then
    pip install -e .
else
    pip install .
fi
