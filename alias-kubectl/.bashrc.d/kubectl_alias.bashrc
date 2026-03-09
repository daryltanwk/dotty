# Check if kubectl is installed
if ! command -v kubectl &>/dev/null; then
  return 0 2>/dev/null || exit 0
fi

source <(kubectl completion bash)
alias k='kubectl'
complete -o default -F __start_kubectl k

# vsphere plugin
if kubectl plugin list 2>/dev/null | grep -q "vsphere"; then
  if command -v kubectl-vsphere &>/dev/null; then
    source <(kubectl vsphere completion bash)
    alias kv='kubectl-vsphere'
    complete -o default -F __start_kubectl-vsphere kv
  fi
fi
