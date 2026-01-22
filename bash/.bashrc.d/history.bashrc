export HISTTIMEFORMAT="%F %T "
shopt -s histappend
HISTSIZE=100000
HISTFILESIZE=10000000
PROMPT_COMMAND="history -a;history -n"
