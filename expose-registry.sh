#!/bin/zsh
#
# Exposes the OpenShift internal container registry by enabling the default
# route on the Image Registry operator. Once exposed, the registry route is
# retrieved and used to update OCP_REGISTRY_URL in demo.env. Requires an
# authenticated oc session with cluster-admin privileges.
#

SCRIPT_DIR="${0:a:h}"
source "${SCRIPT_DIR}/demo.env"

echo "Exposing the OpenShift internal container registry..."
oc patch configs.imageregistry.operator.openshift.io/cluster --type merge -p '{"spec":{"defaultRoute":true}}'

if [[ $? -ne 0 ]]; then
  echo "Error: Failed to patch the Image Registry operator config."
  exit 1
fi

echo "Waiting for the registry route to become available..."
oc wait --for=condition=Available deployment/image-registry -n openshift-image-registry --timeout=60s

ROUTE=$(oc get route default-route -n openshift-image-registry -o jsonpath='{.spec.host}' 2>/dev/null)

if [[ -n "${ROUTE}" ]]; then
  echo "Registry exposed at: ${ROUTE}"

  # Update OCP_REGISTRY_URL in demo.env with the actual route
  if [[ -f "${SCRIPT_DIR}/demo.env" ]]; then
    sed -i '' "s|^OCP_REGISTRY_URL=.*|OCP_REGISTRY_URL=\"${ROUTE}\"|" "${SCRIPT_DIR}/demo.env"
    echo "Updated OCP_REGISTRY_URL in demo.env to: ${ROUTE}"
  fi
else
  echo "Error: Could not retrieve the registry route. Check the openshift-image-registry namespace."
  exit 1
fi

echo "Done."
