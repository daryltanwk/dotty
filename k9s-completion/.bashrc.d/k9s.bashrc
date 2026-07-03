# Check if k9s is installed
if ! command -v k9s &>/dev/null; then
  return 0 2>/dev/null || exit 0
fi

source <(k9s completion bash)