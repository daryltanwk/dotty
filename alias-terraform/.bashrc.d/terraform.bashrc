# Terraform aliases and completion
# Only set up if terraform is installed
if command -v terraform > /dev/null 2>&1; then
  alias t='terraform'

  # Enable terraform autocomplete for both 'terraform' and 't'
  complete -C /usr/bin/terraform t
fi
