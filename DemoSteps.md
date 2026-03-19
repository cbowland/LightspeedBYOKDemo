## Steps for Lightspeed Bring Your Own Knowledge Demo

### Placeholder Reference

| Placeholder | Description | Example |
|-------------|-------------|---------|
| `<OCP_REGISTRY_URL>` | OpenShift internal image registry route | `default-route-openshift-image-registry.apps.cluster-xyz.example.com` |
| `<OLS_NAMESPACE>` | Namespace for OpenShift Lightspeed | `openshift-lightspeed` |
| `<EXTERNAL_REGISTRY>` | External registry (e.g. Quay) | `quay.io` |
| `<REGISTRY_USER>` | Your registry username | `cbowland` |
| `<OUTPUT_DIR>` | Directory for RAG tool output | `/home/lab-user/LightspeedBYOKOutput` |
| `<OC_TAR_URL>` | URL to download the `oc` CLI tar | `https://downloads-openshift-console.apps.cluster-XXXXX.dynamic.redhatworkshops.io/amd64/linux/oc.tar` |

### Provision Demo Instances
* RHEL 9
** https://catalog.demo.redhat.com/catalog?search=rhel+9&item=babylon-catalog-prod%2Fsandboxes-gpte.rhel9-base.prod
* OpensShift with Lightspeed Installed
** https://catalog.demo.redhat.com/catalog?search=lightspeed&item=babylon-catalog-prod%2Fpublished.ocp4-lightspeed.prod

### Set Up RHEL 9 Server
* Run `remote-setup.sh` to install prerequisites (podman, tree) and download the oc CLI
* Run `sync-to-remote.sh` to copy .md files, scripts, and demo.env to the remote server

### Build the new container image
* use podman to log in to registry.redhat.io
* execute podman script
* load tar archive into local podman image store
** podman load -i <OUTPUT_DIR>/byok-image.tar

### Push image to container registry
* Tag image
** podman tag localhost/byok-image:latest <EXTERNAL_REGISTRY>/<REGISTRY_USER>/byok-image:latest
* push image to quay.io
** log in to quay.io
** podman push <EXTERNAL_REGISTRY>/<REGISTRY_USER>/byok-image:latest
* Make image public in quay.io via https://quay.io

### Update OpenShift Lightspeed config
* Add the RAG section to the OLSConfig by running the patch script:
```
./patch-olsconfig-rag.sh
```
* This patches `.spec.ols.rag` on the `cluster` OLSConfig resource with the following:
```
   rag:
     - image: '<OCP_REGISTRY_URL>/<OLS_NAMESPACE>/byok-image:latest'
       indexID: <RAG_INDEX_ID>
       indexPath: <RAG_INDEX_PATH>
```
* To patch a differently named OLSConfig, pass the name as an argument:
```
./patch-olsconfig-rag.sh <olsconfig-name>
```
* To remove the RAG section and revert the OLSConfig, run:
```
./unpatch-olsconfig-rag.sh
```

### Test via the OpenShift Console Lightspeed chat interface
* what sccs does the bowland widget factory require?
* what labels need to be included for the bowland widget factory?
* tell me about the network policy standards for the bowland widget factory
