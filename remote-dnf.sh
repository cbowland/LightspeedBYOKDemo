#!/bin/zsh
#
# Installs prerequisite packages on a remote RHEL host via SSH. Connects to the
# remote host defined in demo.env and uses dnf to install podman (for building
# container images) and tree (for inspecting directory structures). Intended to
# be run once during initial environment setup.
#

SCRIPT_DIR="${0:a:h}"
source "${SCRIPT_DIR}/demo.env"

echo "Installing podman and tree on ${REMOTE_USER}@${REMOTE_HOST}..."
ssh -t "${REMOTE_USER}@${REMOTE_HOST}" "sudo dnf install -y podman tree"

if [[ $? -ne 0 ]]; then
  echo "Error: dnf install failed on remote host."
  exit 1
fi

echo "Done."
