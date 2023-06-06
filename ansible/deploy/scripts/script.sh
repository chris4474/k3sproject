#!/bin/bash -eu
delay=$(( $RANDOM % 20 ))
echo Back in $delay seconds
sleep $delay
rc=$(( $RANDOM % 2 ))
exit $rc
