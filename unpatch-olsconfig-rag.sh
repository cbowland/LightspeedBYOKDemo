#!/bin/zsh
#
# Reverts the RAG configuration added by patch-olsconfig-rag.sh. Uses a JSON patch
# to remove the entire spec.ols.rag array from the OLSConfig custom resource,
# restoring OpenShift Lightspeed to its default (non-RAG) behavior. Accepts an
# optional argument for the OLSConfig name (defaults to "cluster").
#
# Usage: ./unpatch-olsconfig-rag.sh [olsconfig-name]
#

OLSCONFIG_NAME="${1:-cluster}"

oc patch olsconfig "${OLSCONFIG_NAME}" --type json -p '[
  {"op": "remove", "path": "/spec/ols/rag"}
]'
