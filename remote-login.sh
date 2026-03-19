#!/bin/zsh
#
# Authenticates to the OpenShift cluster and container registries on the remote
# RHEL host. Runs three interactive logins in a single SSH session:
#   1. oc login to the OpenShift cluster
#   2. podman login to registry.redhat.io
#   3. podman login to the OpenShift internal registry (using the oc token)
# Prompts for OpenShift and Red Hat registry usernames and passwords locally
# before connecting. No credentials are stored in files.
# Configuration values are sourced from demo.env.
#

SCRIPT_DIR="${0:a:h}"
source "${SCRIPT_DIR}/demo.env"

if [[ -z "${OCP_API_URL}" ]]; then
  echo "Error: OCP_API_URL is not set in demo.env."
  exit 1
fi

if [[ -z "${OCP_REGISTRY_URL}" ]]; then
  echo "Error: OCP_REGISTRY_URL is not set in demo.env."
  exit 1
fi

# Collect credentials locally before SSH
echo "=== OpenShift Cluster Credentials ==="
printf "Username: "
read OCP_USER
printf "Password: "
read -s OCP_PASS
echo ""

echo ""
echo "=== Red Hat Registry Credentials ==="
printf "Username: "
read RH_USER
printf "Password: "
read -s RH_PASS
echo ""

echo ""
echo "Logging in to OpenShift and container registries on ${REMOTE_USER}@${REMOTE_HOST}..."
ssh -t "${REMOTE_USER}@${REMOTE_HOST}" "\
  echo '=== OpenShift Cluster Login ===' && \
  ~/oc login '${OCP_API_URL}' --insecure-skip-tls-verify -u '${OCP_USER}' -p '${OCP_PASS}' && \
  echo '' && \
  echo '=== Red Hat Registry Login ===' && \
  podman login -u '${RH_USER}' -p '${RH_PASS}' registry.redhat.io && \
  echo '' && \
  echo '=== OpenShift Internal Registry Login ===' && \
  podman login -u '${OCP_USER}' -p \$(~/oc whoami -t) '${OCP_REGISTRY_URL}' --tls-verify=false"

if [[ $? -ne 0 ]]; then
  echo "Error: One or more logins failed on the remote host."
  exit 1
fi

echo "Done."
