#!/bin/sh
set -e

cd "$(dirname "$0")/.."

with_groups() {
    echo "::group::$@"
    "$@" && echo "::endgroup::"
}

"$@" autoflake -i -r --remove-all-unused-imports --remove-unused-variables mkdocs_section_index tests
"$@" isort -q mkdocs_section_index tests
"$@" black -q mkdocs_section_index tests
"$@" pytest -q
python -c 'import sys, os; sys.exit((3,8) <= sys.version_info < (3,10) and os.name == "posix")' ||
"$@" pytype mkdocs_section_index
"$@" mkdocs build -f example/mkdocs.yml --strict
