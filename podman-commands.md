# Podman Authentication to Red Hat Registry

Before running the RAG tool, authenticate to the Red Hat container registry. You will be prompted to enter your password after running the command.

## Placeholder Reference

| Placeholder | Description | Example |
|-------------|-------------|---------|
| `<REGISTRY_USERNAME>` | Your Red Hat registry username | (your RH login) |
| `<MARKDOWN_SOURCE_DIR>` | Directory containing source .md files | `/home/lab-user/LightspeedBYOKDemo` |
| `<OUTPUT_DIR>` | Directory for RAG tool output | `/home/lab-user/LightspeedBYOKOutput` |
| `<OCP_REGISTRY_URL>` | OpenShift internal image registry route | `default-route-openshift-image-registry.apps.cluster-xyz.example.com` |
| `<OLS_NAMESPACE>` | Namespace for OpenShift Lightspeed | `openshift-lightspeed` |

```bash
podman login -u <REGISTRY_USERNAME> registry.redhat.io
```

# Podman RAG Tool Command

This command runs the Red Hat OpenShift Lightspeed RAG (Retrieval-Augmented Generation) tool inside a Podman container. It processes markdown files and generates embeddings/index output for use with OpenShift Lightspeed.

## What It Does

| Flag / Argument | Purpose |
|---|---|
| `podman run -it --rm` | Runs the container interactively with a TTY and automatically removes it when it exits. |
| `--device=/dev/fuse` | Grants the container access to the FUSE device, required for filesystem operations inside the container. |
| `-v $XDG_RUNTIME_DIR/containers/auth.json:/run/user/0/containers/auth.json:Z` | Mounts your container registry authentication file into the container so it can pull images if needed. The `:Z` relabels the volume for SELinux. |
| `-v <MARKDOWN_SOURCE_DIR>:/markdown:Z` | Mounts the local directory containing your markdown source files into the container at `/markdown`. |
| `-v <OUTPUT_DIR>:/output:Z` | Mounts a local output directory into the container at `/output` where the generated RAG index will be written. |
| `registry.redhat.io/openshift-lightspeed-tech-preview/lightspeed-rag-tool-rhel9:latest` | The RAG tool container image from the Red Hat registry. |

## Command

```bash
podman run -it --rm --device=/dev/fuse \
  -v $XDG_RUNTIME_DIR/containers/auth.json:/run/user/0/containers/auth.json:Z \
  -v <MARKDOWN_SOURCE_DIR>:/markdown:Z \
  -v <OUTPUT_DIR>:/output:Z \
registry.redhat.io/openshift-lightspeed-tech-preview/lightspeed-rag-tool-rhel9:latest
```

# Login to OpenShift Cluster

Log in to the OpenShift cluster using your API token. You can obtain your token from the OpenShift web console.

```bash
oc login \
  --token=<YOUR_TOKEN> \
  --server=<YOUR_API_SERVER>
```

## Login to OpenShift Image Registry

Authenticate Podman to the OpenShift internal image registry. The username can be any value as authentication is handled by the OpenShift token. The `-p $(oc whoami -t)` flag uses your current OpenShift session token as the password.

```bash
podman login \
  -u any_username \
  -p $(oc whoami -t) \
  <OCP_REGISTRY_URL>
```

# Push Your Knowledge

Load, tag, and push the resulting image to your container registry.

```bash
podman load \
  -i <OUTPUT_DIR>/byok-image.tar
podman tag \
  localhost/byok-image:latest \
  <OCP_REGISTRY_URL>/<OLS_NAMESPACE>/byok-image:latest
podman push \
  <OCP_REGISTRY_URL>/<OLS_NAMESPACE>/byok-image:latest
```
