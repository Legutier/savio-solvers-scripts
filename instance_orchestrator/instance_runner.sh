#!/bin/bash

sleep 3
echo "processing $2  for $1 at $(date '+%T')"
output=$($1 $2)
echo "$output"
exit 0
