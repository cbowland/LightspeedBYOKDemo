# Bowland Widget Factory: ConfigMap and Secret Standards



## 1. Overview
Separation of configuration from application code is required to maintain 12-Factor App compliance.

## 2. ConfigMap Standards
* **Usage:** ConfigMaps MUST be used for all non-sensitive configuration data (e.g., environment variables, XML/JSON config files).
* **Immutability:** Wherever possible, ConfigMaps SHOULD have `immutable: true` set. This prevents accidental runtime changes, forces a safe pod rollout for config updates, and reduces load on the Kubernetes API server.
* **Naming:** Must follow the pattern `<app-name>-config`.

## 3. Secret Standards
* **Usage:** Secrets MUST be used for passwords, API keys, TLS certificates, and tokens.
* **Declarative Format:** When generating declarative YAML for Secrets, use the `stringData` field instead of `data`. This allows developers to read the generated template easily before it is base64-encoded by the cluster.
* **Type:** Default to `type: Opaque` unless a specific structural type (like `kubernetes.io/tls` or `kubernetes.io/dockerconfigjson`) is strictly required.
* **Immutability:** Like ConfigMaps, Secrets SHOULD use `immutable: true` when values are not expected to rotate dynamically without a pod restart.