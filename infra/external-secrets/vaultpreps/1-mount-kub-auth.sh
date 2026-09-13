#!/bin/bash
#
# set environment specific variables
#
. env.sh

vault auth enable -path=kub-${cluster} kubernetes

