#!/usr/bin/env bash
# Deploy the Helm chart to an ephemeral namespace (suitable for a Kind cluster in CI)
# Usage: deploy.sh [namespace] [release] [chart_dir]
# defaults: namespace=node-hello-<timestamp>, release=node-hello-test, chart_dir=./helm

set -euo pipefail

NAMESPACE="${1:-node-hello-$(date +%s)}"
RELEASE="${2:-node-hello-test}"
CHART_DIR="${3:-./helm}"
TIMEOUT="${HELM_WAIT_TIMEOUT:-120s}"

if ! command -v kubectl >/dev/null 2>&1; then
  echo "kubectl is required but not found in PATH" >&2
  exit 2
fi
if ! command -v helm >/dev/null 2>&1; then
  echo "helm is required but not found in PATH" >&2
  exit 2
fi

echo "Creating namespace: ${NAMESPACE}"
kubectl create ns "${NAMESPACE}" || true

# Install chart with --wait so helm waits for readiness probes (if defined in chart)
echo "Installing Helm release '${RELEASE}' into namespace '${NAMESPACE}' from chart '${CHART_DIR}'"
helm upgrade --install "${RELEASE}" "${CHART_DIR}" -n "${NAMESPACE}" --wait --timeout "${TIMEOUT}"

# Wait for deployments to be rolled out
echo "Waiting for deployments to rollout in namespace ${NAMESPACE}"
# Find all deployments in the namespace and wait on them
DEPLOYMENTS=$(kubectl -n "${NAMESPACE}" get deployments -o jsonpath='{range .items[*]}{.metadata.name} {end}') || true
if [ -n "${DEPLOYMENTS}" ]; then
  for dep in ${DEPLOYMENTS}; do
    echo "Waiting rollout status for deployment: ${dep}"
    kubectl -n "${NAMESPACE}" rollout status deployment/${dep} --timeout=120s
  done
fi

# Wait for pods to become ready (fallback if Helm's --wait didn't catch something)
echo "Waiting for pods to be ready in namespace ${NAMESPACE}"
kubectl -n "${NAMESPACE}" wait --for=condition=ready pod --all --timeout=120s

# Optionally, run a basic behavior check: hit the service using a temporary curl pod
# This is useful in CI where cluster networking is available.
SERVICE_NAME="${RELEASE}"
SVC_PORT=${SVC_PORT:-3000}

echo "Attempting a basic HTTP check by running a temporary curl pod against the service"
kubectl -n "${NAMESPACE}" run --rm -i --restart=Never curl-test --image=curlimages/curl --command -- \
  sh -c "until curl -sS http://${SERVICE_NAME}:${SVC_PORT}/; do echo waiting...; sleep 1; done; echo OK" || true

echo "Helm release ${RELEASE} installed into namespace ${NAMESPACE} and readiness verified."
