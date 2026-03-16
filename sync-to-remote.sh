#!/bin/zsh

# Resolve the script's directory so paths are relative to it
SCRIPT_DIR="${0:a:h}"
source "${SCRIPT_DIR}/demo.env"

LOCAL_SOURCE_PATH="${SCRIPT_DIR}/${LOCAL_SOURCE_NAME}"

# Verify local source directory exists and has .md files
if [[ ! -d "${LOCAL_SOURCE_PATH}" ]]; then
  echo "Error: Local source directory '${LOCAL_SOURCE_PATH}' does not exist."
  exit 1
fi

md_files=("${LOCAL_SOURCE_PATH}"/*.md(N))
if [[ ${#md_files[@]} -eq 0 ]]; then
  echo "Error: No .md files found in '${LOCAL_SOURCE_PATH}'."
  exit 1
fi

# Create remote directories if they don't exist
echo "Ensuring remote directories exist..."
ssh "${REMOTE_USER}@${REMOTE_HOST}" "mkdir -p ~/${REMOTE_SOURCE_NAME} ~/${REMOTE_SOURCE_TARGET}"

if [[ $? -ne 0 ]]; then
  echo "Error: Failed to create remote directories."
  exit 1
fi

# Copy .md files to the remote source directory
echo "Copying ${#md_files[@]} .md file(s) to ${REMOTE_USER}@${REMOTE_HOST}:~/${REMOTE_SOURCE_NAME}/"
scp "${LOCAL_SOURCE_PATH}"/*.md "${REMOTE_USER}@${REMOTE_HOST}:~/${REMOTE_SOURCE_NAME}/"

if [[ $? -ne 0 ]]; then
  echo "Error: Failed to copy files."
  exit 1
fi

echo "Done."
