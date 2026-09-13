#!/bin/bash
#
# set environment specific variables
#
. env.sh

vault write auth/kub-${cluster}/role/eso-role \
    bound_service_account_names="external-secrets" \
    bound_service_account_namespaces="external-secrets" \
    policies="eso-policy-${cluster}"

