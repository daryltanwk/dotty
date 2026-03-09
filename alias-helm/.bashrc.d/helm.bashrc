# Helm configuration
# Source helm completion if helm is installed

if command -v helm &>/dev/null; then
  source <(helm completion bash)

  # Source helm-images plugin completion if installed
  if helm plugin list 2>/dev/null | grep -q '^images '; then
    source <(helm images completion bash)
  fi
fi
