#!/bin/zsh

# Removes the RAG section from the OLSConfig resource under spec.ols

OLSCONFIG_NAME="${1:-cluster}"

oc patch olsconfig "${OLSCONFIG_NAME}" --type json -p '[
  {"op": "remove", "path": "/spec/ols/rag"}
]'
