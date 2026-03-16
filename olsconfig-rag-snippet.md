# OLSConfig RAG YAML Snippet

This is a YAML snippet to manually add RAG (Retrieval-Augmented Generation) support to the `OLSConfig` custom resource via the OpenShift console or by editing the resource directly. It configures Lightspeed to use a custom RAG index image for augmented responses.

## Placeholder Reference

| Placeholder | Description | Example |
|-------------|-------------|---------|
| `<OCP_REGISTRY_URL>` | OpenShift internal image registry route | `default-route-openshift-image-registry.apps.cluster-xyz.example.com` |
| `<OLS_NAMESPACE>` | Namespace for OpenShift Lightspeed | `openshift-lightspeed` |
| `<RAG_INDEX_ID>` | Vector DB index identifier | `vector_db_index` |
| `<RAG_INDEX_PATH>` | Path to vector DB inside container | `/rag/vector_db` |

## Where to Add It

In the `OLSConfig` resource, add this block under `spec.ols`, at the same indent level as `userDataCollection`:

```yaml
    rag:
      - image: '<OCP_REGISTRY_URL>/<OLS_NAMESPACE>/byok-image:latest'
        indexID: <RAG_INDEX_ID>
        indexPath: <RAG_INDEX_PATH>
```

## Field Descriptions

| Field | Purpose |
|---|---|
| `image` | The custom RAG index container image, hosted in the cluster's internal image registry under the `<OLS_NAMESPACE>` namespace. |
| `indexID` | The identifier for the vector database index. |
| `indexPath` | The path inside the container where the vector database is stored. |

## Example Context

```yaml
spec:
  ols:
    userDataCollection: {}
    rag:
      - image: '<OCP_REGISTRY_URL>/<OLS_NAMESPACE>/byok-image:latest'
        indexID: <RAG_INDEX_ID>
        indexPath: <RAG_INDEX_PATH>
```
