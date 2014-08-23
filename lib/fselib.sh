#!/usr/bin/env bash

# functions for FSEterm scripts
warn () {
  echo "${BASH_SOURCE[1]}:WARN: $@" 1>&2
}

# The output formatter is naive. When converting formats, it doesn't bother
# with quoting or escaping embedded delimiters. I know this is not ideal, but
# I plan on replacing it in the future with something more robust. To my
# knowledge none of the FSE data has an embedded tab or an embedded comma, so
# it shouldn't bite us in the meantime.

# Input format is CSV
output_formatter() {
  # If an output format has not been selected, then we select a default.
  if [[ ! $fmt ]]; then
    if [[ -t 1 ]]; then
      fmt="col"
    else
      fmt="csv"
    fi
  fi

  case "${fmt,,}" in
    csv)
      # use tr to convert tabs to commas
      cat -
      ;;

    col)
      # use the column formatter. I hope it exists in OS X?!
      column -t -s ',' <&0
      ;;

    tab)
      # tab is the native format we're using, so cat it out.
      tr ',' '	'
      ;;

  esac
}
