#!/bin/bash

#
# Initialize the custom data directory layout

# shellcheck disable=SC1091
source /data_dirs.sh

cd /var/ossec || exit 1
for ossecdir in "${DATA_DIRS[@]}"; do
  mv "${ossecdir}" "${ossecdir}-template"
  ln -s "data/${ossecdir}" "${ossecdir}"
done

ln -s ../data/process_list bin/.process_list
