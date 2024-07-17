#!/bin/bash

function print_usage {
  for key in "${!arg_desc[@]}"; do
    echo "  $key    ${arg_desc[$key]}"
  done
}

function parse_args {
  local OPTIONS=""
  local LONGOPTIONS=""

  for key in "${!arg_desc[@]}"; do
    short_opt=$(echo "$key" | cut -d, -f1)
    long_opt=$(echo "$key" | cut -d, -f2)

    OPTIONS+="${short_opt:1:1}:"
    LONGOPTIONS+="${long_opt:2}:,"
  done

  local PARSED
  PARSED=$(getopt --options="$OPTIONS" --longoptions="${LONGOPTIONS%,}" --name "$0" -- "$@")

  if [[ $? -ne 0 ]]; then
    print_usage
    exit 1
  fi

  eval set -- "$PARSED"

  while true; do
    case "$1" in
      --)
        shift
        break
        ;;
      *)
        for key in "${!arg_desc[@]}"; do
          short_opt=$(echo "$key" | cut -d, -f1)
          long_opt=$(echo "$key" | cut -d, -f2)
          if [[ "$1" == "$short_opt" || "$1" == "$long_opt" ]]; then
            var_name=$(echo "$long_opt" | sed 's/--//;s/-/_/g')
            parsed_args["$var_name"]=$(echo "$2" | sed 's/^=//')
            shift 2
            break
          fi
        done
        ;;
    esac
  done
}
