#!/bin/bash
#
# Bash-compatible version of unpatch-olsconfig-rag.sh, intended for execution on
# remote hosts that may not have zsh installed. Reverts the RAG configuration by
# removing the entire spec.ols.rag array from the OLSConfig custom resource,
# restoring OpenShift Lightspeed to its default (non-RAG) behavior. Accepts an
# optional argument for the OLSConfig name (defaults to "cluster").
#
# Usage: ./unpatch-olsconfig-rag-bash.sh [olsconfig-name]
#

OLSCONFIG_NAME="${1:-cluster}"

oc patch olsconfig "${OLSCONFIG_NAME}" --type json -p '[
  {"op": "remove", "path": "/spec/ols/rag"}
]'
