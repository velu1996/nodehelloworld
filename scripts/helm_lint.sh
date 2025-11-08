#!/usr/bin/env bash
# Lint a Helm chart directory. Exits non-zero on failure.

set -euo pipefail

CHART_DIR="${1:-./helm}"

echo "Running helm lint for chart directory: ${CHART_DIR}"

if ! command -v helm >/dev/null 2>&1; then
  echo "helm is required but not found in PATH" >&2
  exit 2
fi

helm lint "${CHART_DIR}" \
  || { echo "helm lint failed" >&2; exit 1; }

echo "helm lint succeeded for ${CHART_DIR}"