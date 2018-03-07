#!/bin/bash

set -e

if ./setup/check_venv.sh
then
    echo "Not in venv, please activate it first."
    exit 1
fi
echo "Running flake8..."
flake8 --statistics .
echo -e "\nFLAKE8: PASSED"
