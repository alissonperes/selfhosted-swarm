#!/bin/bash

set -euo pipefail

IMAGE_NAME="ansible-runner"
SCRIPT_DIR="$(dirname "$(realpath "$0")")"
ROOT_DIR="$(realpath "$SCRIPT_DIR/..")"
CONFIGS_DIR="$SCRIPT_DIR/configs"  # local path: ./ansible/configs

# Ensure SSH agent is running
if [ -z "${SSH_AUTH_SOCK:-}" ]; then
  echo "[-] SSH agent is not running or SSH_AUTH_SOCK is not set."
  echo "    Run 'eval \$(ssh-agent)' and 'ssh-add' first."
  exit 1
fi

echo "[+] Building Ansible image..."
docker build -t "$IMAGE_NAME" "$SCRIPT_DIR" || {
  echo "[-] Failed to build Docker image"
  exit 1
}

echo "[+] Running Ansible playbook..."
docker run --rm -it \
  -v "$ROOT_DIR:/ansible-hosted" \
  -v "$CONFIGS_DIR:/opt/configs" \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v "$SSH_AUTH_SOCK:/ssh-agent" \
  -e SSH_AUTH_SOCK=/ssh-agent \
  -e ANSIBLE_HOST_KEY_CHECKING=False \
  -w /ansible-hosted/ansible \
  "$IMAGE_NAME" \
  -i inventory.ini deploy-all.yml || {
    echo "[-] Ansible playbook execution failed"
    exit 2
}

echo "[✓] Deployment completed successfully."
