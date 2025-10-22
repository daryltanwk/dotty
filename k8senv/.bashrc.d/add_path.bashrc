CUSTOM_DIR="$HOME/.k8senv/bin"

if [ ! -d "$CUSTOM_DIR" ]; then
    echo "Warning: Custom PATH directory '$CUSTOM_DIR' does not exist." >&2
else
    if [[ ":$PATH:" != *":$CUSTOM_DIR:"* ]]; then
        export PATH="$PATH:$CUSTOM_DIR"
    fi
fi

unset CUSTOM_DIR
