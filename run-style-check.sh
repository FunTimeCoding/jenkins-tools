#!/bin/sh -e

find . -name '*.sh' -exec sh -c "shellcheck {} || true" \;
