#!/bin/bash

#
# Initialize the custom data directory layout
#
source /data_dirs.env

cd /var/ossec
for ossecdir in "${DATA_DIRS[@]}"; do
  mv ${ossecdir} ${ossecdir}-template
  ln -s data/${ossecdir} ${ossecdir}
done

ln -s ../data/process_list bin/.process_list
