#!/bin/bash
#
# set environment specific variables
#
. env.sh

vault secrets enable -path=secret-${cluster} kv-v2
