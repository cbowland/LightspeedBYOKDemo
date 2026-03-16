#!/bin/zsh

# Patches the OLSConfig resource to add a RAG section under spec.ols

SCRIPT_DIR="${0:a:h}"
source "${SCRIPT_DIR}/demo.env"

OLSCONFIG_NAME="${1:-cluster}"

oc patch olsconfig "${OLSCONFIG_NAME}" --type merge -p '{
  "spec": {
    "ols": {
      "rag": [
        {
          "image": "'"${OCP_REGISTRY_URL}/${OLS_NAMESPACE}/byok-image:latest"'",
          "indexID": "'"${RAG_INDEX_ID}"'",
          "indexPath": "'"${RAG_INDEX_PATH}"'"
        }
      ]
    }
  }
}'
