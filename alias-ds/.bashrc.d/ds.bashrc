ds() {
    if [ $# -eq 0 ]; then
        du -had 1 . | sort -h
    else
        du -had 1 "$1" | sort -h
    fi
}