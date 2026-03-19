#!/bin/zsh
#
# Patches the OLSConfig custom resource to enable Retrieval-Augmented Generation (RAG)
# for OpenShift Lightspeed. Adds a RAG entry under spec.ols that points to a custom
# container image in the cluster's internal registry, along with the RAG index ID and
# path. Configuration values are sourced from demo.env. Accepts an optional argument
# for the OLSConfig name (defaults to "cluster").
#
# Usage: ./patch-olsconfig-rag.sh [olsconfig-name]
#

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
