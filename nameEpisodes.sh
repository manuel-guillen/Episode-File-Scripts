#!/bin/bash
declare -i season
declare -i episode

# Assert that there is at most one argument
if [ $# -gt 1 ]; then
  echo "Usage: $0 [directory]"
  exit 1
fi

# If there is an argument, assert it is a directory and change to it
if [ -n "$1" ]; then
  if [ -d "$1" ]; then
    cd "$1"
  else
    echo "Usage: $0 [directory]"
    exit 1
  fi
fi

# For each episode file, rename it to include the episode name
for file in S??E??.mkv
do
  season=$((10#${file:1:2}))
  episode=$((10#${file:4:2}))
  tsvFile="season${season}.tsv"

  # Check if TSV file exists
  if [! -f "$tsvFile" ]; then
    echo "Episode name TSV file not found: $tsvFile"
    exit 2
  fi

  name=$(awk -v episode="$episode" -F'\t' '$1 == episode {print $2}' "$tsvFile")
  if [ -n "$name" ]; then
    mv "$file" "($season.$episode) $name.mkv"
  fi
done

# For each special episode file, rename it to include the episode name
for file in S??E00*" (Special).mkv"; do
  season=$((10#${file:1:2}))
  tsvFile="season${season}.tsv"

  # Check if TSV file exists
  if [! -f "$tsvFile" ]; then
    echo "Episode name TSV file not found: $tsvFile"
    exit 2
  fi

  name=$(sed -n 's/.*- \(.*\) (Special).mkv/\1/p' <<< "$file")
  cleaned_name=$(echo "$name" | tr -dc '[:alnum:]' | tr '[:upper:]' '[:lower:]')

  while read -r line || [ -n "$line" ]; do
    read field1 field2 <<< "$line"
    cleaned_field2=$(echo "$field2" | tr -dc '[:alnum:]' | tr '[:upper:]' '[:lower:]')
    if [ "$cleaned_field2" == "$cleaned_name" ]; then
      mv "$file" "($season.$field1) $name.mkv"
      break
    fi
  done < "$tsvFile"
done