[ "$TERM_PROGRAM" = "Apple_Terminal" ] && shell_session_update

# cdx command
\rm /tmp/PWD/${TTY} 2>/dev/null

# cdh commnad
tmp=$(tac ~/.pwd_history | awk '!a[$0]++' | tac) && echo $tmp | tr " " "\n" > ~/.pwd_history

# ssh-agent
ssh-agent -k 2>/dev/null
