#!/bin/bash

function scripttest {
    echo -ne "\nPython cleaning test... "
    stagedfiles=$(git diff --cached --name-only | grep '.py$')
    if [ -z "$stagedfiles" ]; then
        echo -e "SKIPPED (No staged Python files)"
        return 0
    fi

    unformatted=$(yapf --diff $stagedfiles | grep "(reformatted)" | awk '{print $2}')
    failed=$?
    if [ -z "$unformatted" ]; then
        if [ -n "$failed" ]; then
            echo -e "FAILED (Formatter crashed)"
            return 1
        fi
        echo -e "PASSED"
        return 0
    fi

    echo -e "FAILED (Formatting)\n\n  The following files are not formatted properly:"
    for fn in $unformatted; do
        echo "    $fn"
    done

    echo -e "\n  Python files must be formatted with YAPF. Please run:"
    echo "    ./setup/clean.sh"
    return 1
}

function notebooktest {
    echo -ne "\nNotebook cleaning test... "
    stagedfiles=$(git diff --cached --name-only | grep '.ipynb$')
    if [ -z "$stagedfiles" ]; then
        echo -e "SKIPPED (No staged notebooks)"
        return 0
    fi

    unformatted=$(python setup/yapf_nbformat.py --dry_run $stagedfiles | grep "(reformatted)" | awk '{print $2}')
    failed=$?
    if [ -z "$unformatted" ]; then
        if [ -n "$failed" ]; then
            echo -e "FAILED (Formatter crashed)"
            return 1
        fi
        echo -e "PASSED"
        return 0
    fi

    echo -e "FAILED (Formatting)\n\n  The following files are not formatted properly:"
    for fn in $unformatted; do
        echo "    $fn"
    done

    echo -e "\n  Notebook files must be formatted with a custom nbformat-YAPF script. Please run:"
    echo "    ./setup/clean.sh"
    return 1
}

# Redirect output to stderr.
exec 1>&2

echo "Running pre-commit hooks..."

./setup/tests.sh
RESULT=$?
[ $RESULT -ne 0 ] && exit 1

scripttest || exit 1
notebooktest || exit 1

echo -e "\nPre-commit hooks PASSED"
