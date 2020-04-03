[ "$TERM_PROGRAM" = "Apple_Terminal" ] && shell_session_update

# cdx command
rm /tmp/PWD/${TTY} 2>/dev/null

# cdh commnad
sort -u ~/.pwd_history -o ~/.pwd_history

# ssh-agent
ssh-agent -k
