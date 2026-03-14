## Steps for Lightspeed Bring Your Own Knowledge Demo

### Provision Demo Instances
* RHEL 9
** https://catalog.demo.redhat.com/catalog?search=rhel+9&item=babylon-catalog-prod%2Fsandboxes-gpte.rhel9-base.prod
* OpensShift with Lightspeed Installed
** https://catalog.demo.redhat.com/catalog?search=lightspeed&item=babylon-catalog-prod%2Fpublished.ocp4-lightspeed.prod

### Set Up RHEL 9 Server
* ssh into box
* create BYOK-output directory
* create Lightspeed-BYOK directory
* scp all needed .md files to the Lightspeed-BYOK directory
* scp podman script to the home directory of the user

### Build the new container image
* use podman to log in to registry.redhat.io
* execute podman script
* load tar archive into local podman image store
** podman load -i BYOK-output/byok-image.tar

### Push image to container registry
* Tag image
** podman tag localhost/byok-image:latest quay.io/cbowland/byok-image:latest
* push image to quay.io
** log in to quay.io
** podman push quay.io/cbowland/byok-image:latest
* Make image public in quay.io via https://quay.io

### Update OpenShift Lightspeed config
* edit the OLSConfig in the Lightspeed Operator
** The rag keyword must be at the same indentation level as defaultModel
** .spec.ols.rag
```
   rag:
     - image: quay.io/cbowland/byok-image:latest
       indexID: vector_db_index
       indexPath: /rag/vector_db
```

### Test via the OpenShift Console Lightspeed chat interface
* what sccs does the bowland widget factory require?
* what labels need to be included for the bowland widget factory?
* tell me about the network policy standards for the bowland widget factory 

