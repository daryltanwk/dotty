export HISTTIMEFORMAT="%F %T "
shopt -s histappend
HISTSIZE=50000
HISTFILESIZE=100000
HISTCONTROL=ignoredups:erasedups
PROMPT_COMMAND="history -a"
