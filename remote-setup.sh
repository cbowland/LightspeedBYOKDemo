#!/bin/zsh
#
# Installs prerequisite packages on a remote RHEL host via SSH. Connects to the
# remote host defined in demo.env and uses dnf to install podman (for building
# container images) and tree (for inspecting directory structures). Also
# downloads and extracts the oc CLI tar from the URL specified by OC_TAR_URL in
# demo.env into the user's home directory. Intended to be run once during
# initial environment setup.
#

SCRIPT_DIR="${0:a:h}"
source "${SCRIPT_DIR}/demo.env"

echo "Installing podman and tree on ${REMOTE_USER}@${REMOTE_HOST}..."
ssh -t "${REMOTE_USER}@${REMOTE_HOST}" "sudo dnf install -y podman tree"

if [[ $? -ne 0 ]]; then
  echo "Error: dnf install failed on remote host."
  exit 1
fi

# Download and extract the oc CLI tar on the remote host
if [[ -n "${OC_TAR_URL}" ]]; then
  echo "Downloading and extracting oc CLI from ${OC_TAR_URL}..."
  ssh -t "${REMOTE_USER}@${REMOTE_HOST}" "curl -kL '${OC_TAR_URL}' | tar xf - -C ~/"

  if [[ $? -ne 0 ]]; then
    echo "Error: Failed to download or extract oc tar on remote host."
    exit 1
  fi
else
  echo "Warning: OC_TAR_URL is not set in demo.env, skipping oc CLI install."
fi

echo "Done."
