#!/bin/bash

git status
version=$(git describe --tags --dirty)

# version can be empty when there are no tags, use rev-parse in that case
# to log the last commit id
if [[ -z "$version" ]]; then
  diff=$(git diff)
  version=$(git rev-parse --short HEAD)

  if [[ -n "$diff" ]]; then
    version=${version}-dirty
  fi
fi

echo version: $version
