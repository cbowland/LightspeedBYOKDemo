# sync-to-remote.sh

A zsh script that syncs `.md` files, bash-compatible OLSConfig scripts, and `demo.env` from a local directory to a remote server over SSH.

## Prerequisites

- SSH key-based authentication configured between the local machine and the remote server
- zsh shell

## Configuration

The following variables are defined at the top of the script:

| Variable | Description |
|---|---|
| `REMOTE_USER` | SSH username (e.g., `your-username`) |
| `REMOTE_HOST` | SSH hostname (e.g., `your-server.example.com`) |
| `LOCAL_SOURCE_NAME` | Local directory containing `.md` files (relative to the script's location) |
| `REMOTE_SOURCE_NAME` | Remote directory where `.md` files will be copied (created under `~/`) |
| `REMOTE_SOURCE_TARGET` | Remote output directory (created under `~/`) |

## What It Does

1. Resolves the script's directory and locates the local source directory relative to it.
2. Validates that the local source directory exists and contains `.md` files.
3. Connects to `your-username@your-server.example.com` via SSH and creates the remote source and target directories under `~/` if they don't already exist.
4. Copies all `.md` files from the local source directory to the remote source directory using `scp`.
5. Copies `demo.env` to the remote source directory if it exists locally.

## Usage

```zsh
./sync-to-remote.sh
```

## Script Source

```zsh
#!/bin/zsh

# Remote connection
REMOTE_USER="your-username"
REMOTE_HOST="your-server.example.com"

# Local source directory (relative to this script's location)
LOCAL_SOURCE_NAME="BowlandWidgetFactoryOCPStandards"

# Remote directories (will be created under ~/ on the remote server)
REMOTE_SOURCE_NAME="LightspeedBYOKDemo"
REMOTE_SOURCE_TARGET="LightspeedBYOKOutput"

# Resolve the script's directory so local source is relative to it
SCRIPT_DIR="${0:a:h}"
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
```
