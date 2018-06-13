#!/bin/bash

export RELX_REPLACE_OS_VARS=true

for i in `seq 1 3`;
do
    NODE_NAME=node_$i ../_build/default/rel/s3_chunk/bin/s3_chunk-0.0.1 foreground &
    sleep 1
done