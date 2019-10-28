#!/bin/bash

SCRIPT=$(readlink -f "$0")
DIR=$(dirname "$SCRIPT")
echo "Cur dir: $DIR"

mkdir -p dev_sources
cd dev_sources


echo "Fetch or update the spark source"
if [[ -d "$DIR/dev_sources/spark" ]]; then
    git pull
else
    git clone https://github.com/apache/spark
fi