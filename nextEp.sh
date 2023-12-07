#!/bin/bash

# Assert no arguments are provided
if [ $# -gt 0 ]; then
    echo "Usage: $0"
    exit 1
fi

record_season=999
record_episode=999
record_special=999

for file in *
do
  regex=".*\(([0-9]+)\.([0-9]+)(Sp([0-9]+))?\).*"

  if [[ $file =~ $regex ]]; then
    season_number=${BASH_REMATCH[1]}
    episode_number=${BASH_REMATCH[2]}
    special_number=${BASH_REMATCH[4]:-0}

    if [ $season_number -lt $record_season -o \
         $season_number -eq $record_season -a $episode_number -lt $record_episode -o \
         $season_number -eq $record_season -a $episode_number -eq $record_episode -a $special_number -lt $record_special ]; then
      
      record_season=$season_number
      record_episode=$episode_number
      record_special=$special_number
      record_file="$file"
    fi
  fi
done

if [ -t 1 ]; then
  echo "$record_file"
else
  printf "%s" "$record_file"
fi
