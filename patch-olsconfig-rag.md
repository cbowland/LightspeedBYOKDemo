# Patch OLSConfig RAG

This script patches the `OLSConfig` custom resource on an OpenShift cluster to add a RAG (Retrieval-Augmented Generation) configuration. This tells OpenShift Lightspeed where to find the custom RAG index image and how to use it.

## Placeholder Reference

| Placeholder | Description | Example |
|-------------|-------------|---------|
| `<OCP_REGISTRY_URL>` | OpenShift internal image registry route | `default-route-openshift-image-registry.apps.cluster-xyz.example.com` |
| `<OLS_NAMESPACE>` | Namespace for OpenShift Lightspeed | `openshift-lightspeed` |
| `<RAG_INDEX_ID>` | Vector DB index identifier | `vector_db_index` |
| `<RAG_INDEX_PATH>` | Path to vector DB inside container | `/rag/vector_db` |

## What It Does

| Part | Purpose |
|---|---|
| `OLSCONFIG_NAME="${1:-cluster}"` | Uses the first argument as the OLSConfig resource name, defaulting to `cluster` if none is provided. |
| `oc patch olsconfig` | Uses the OpenShift CLI to patch the OLSConfig custom resource. |
| `--type merge` | Performs a strategic merge patch, adding or updating fields without removing existing ones. |
| `spec.ols.rag` | Adds a RAG configuration array under the OLS spec. |
| `image` | Points to the custom RAG index image in the cluster's internal image registry. |
| `indexID` | The identifier for the vector database index. |
| `indexPath` | The path inside the container where the vector database is stored. |

## Usage

Optionally pass the OLSConfig resource name as an argument (defaults to `cluster`):

```bash
./patch-olsconfig-rag.sh [olsconfig-name]
```

## Command

```bash
OLSCONFIG_NAME="${1:-cluster}"

oc patch olsconfig "${OLSCONFIG_NAME}" --type merge -p '{
  "spec": {
    "ols": {
      "rag": [
        {
          "image": "<OCP_REGISTRY_URL>/<OLS_NAMESPACE>/byok-image:latest",
          "indexID": "<RAG_INDEX_ID>",
          "indexPath": "<RAG_INDEX_PATH>"
        }
      ]
    }
  }
}'
```
