# Unpatch OLSConfig RAG

This script removes the RAG (Retrieval-Augmented Generation) configuration from the `OLSConfig` custom resource on an OpenShift cluster, reverting Lightspeed to its default behavior without custom RAG data.

## What It Does

| Part | Purpose |
|---|---|
| `OLSCONFIG_NAME="${1:-cluster}"` | Uses the first argument as the OLSConfig resource name, defaulting to `cluster` if none is provided. |
| `oc patch olsconfig` | Uses the OpenShift CLI to patch the OLSConfig custom resource. |
| `--type json` | Uses a JSON Patch (RFC 6902), which supports explicit remove operations. |
| `"op": "remove", "path": "/spec/ols/rag"` | Removes the entire `rag` array from `spec.ols`, undoing the patch applied by `patch-olsconfig-rag.sh`. |

## Usage

Optionally pass the OLSConfig resource name as an argument (defaults to `cluster`):

```bash
./unpatch-olsconfig-rag.sh [olsconfig-name]
```

## Command

```bash
OLSCONFIG_NAME="${1:-cluster}"

oc patch olsconfig "${OLSCONFIG_NAME}" --type json -p '[
  {"op": "remove", "path": "/spec/ols/rag"}
]'
```
