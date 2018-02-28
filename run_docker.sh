#!/bin/bash

set -e

pass="$1"
if [ -z $pass ]; then
    echo "Please supply a Jupyter notebook password as the first parameter."
    exit 1
fi

# TODO: Run docker without sudo
cmd="sudo docker run bceth/mammography -d -e PASSWORD=$pass -p 8888:8888 -p 6006:6006"
echo "Running: $cmd"
eval "$cmd"
