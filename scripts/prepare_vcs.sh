#!/bin/bash
WORKSPACE=$1
VCS_REPOS=$2
vcs_source="$VCS_REPOS"

if [ -d $HOME/"$WORKSPACE" ]; then
  if [ -f "$vcs_source" ]; then
    echo "vcs_source: $vcs_source exists"
  else
    echo "ERROR: $vcs_source does not exist"
    exit 1
  fi
  cp "$vcs_source" $HOME/"$WORKSPACE" > /dev/null 2>&1
else
  echo "ERROR: $WORKSPACE does not exist"
  exit 1
fi
